import pytest
import brownie


def test_performance_fees(chain, gov, vault, token, TestStrategy, rewards, strategist):
    vault.setManagementFee(0, {"from": gov})
    vault.setPerformanceFee(450, {"from": gov})

    assert vault.balanceOf(rewards) == 0
    assert vault.balanceOf(strategist) == 0

    strategy = strategist.deploy(TestStrategy, vault)
    vault.addStrategy(strategy, 10 ** 18, 1000, 50, {"from": gov})
    token.transfer(strategy, 10 ** 8, {"from": gov})
    chain.sleep(1)  # Reverts if no delta time
    strategy.harvest({"from": strategist})

    assert vault.balanceOf(rewards) == 0.045 * 1e8
    assert vault.balanceOf(strategist) == 0.005 * 1e8


def test_zero_fees(chain, gov, vault, token, TestStrategy, rewards, strategist):
    vault.setManagementFee(0, {"from": gov})
    vault.setPerformanceFee(0, {"from": gov})

    assert vault.balanceOf(rewards) == 0
    assert vault.balanceOf(strategist) == 0

    strategy = strategist.deploy(TestStrategy, vault)
    vault.addStrategy(strategy, 10 ** 18, 1000, 0, {"from": gov})
    token.transfer(strategy, 10 ** 8, {"from": gov})
    chain.sleep(1)  # Reverts if no delta time
    strategy.harvest({"from": strategist})

    assert vault.managementFee() == 0
    assert vault.performanceFee() == 0
    assert vault.strategies(strategy).dict()["performanceFee"] == 0
    assert vault.balanceOf(rewards) == 0
    assert vault.balanceOf(strategist) == 0
