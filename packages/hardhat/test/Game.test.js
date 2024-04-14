// File: test/DailyGame.test.js

const DailyGame = artifacts.require("DailyGame");

contract("DailyGame", (accounts) => {
  let dailyGameInstance;

  before(async () => {
    dailyGameInstance = await DailyGame.deployed();
  });

  it("should return an empty array if no participants have submitted their addresses", async () => {
    const participants = await dailyGameInstance.getParticipants();
    assert.deepEqual(participants, []);
  });

  it("should allow a participant to submit their address", async () => {
    const sender = accounts[0];
    await dailyGameInstance.submitAddress({ from: sender });

    const participants = await dailyGameInstance.getParticipants();
    assert.deepEqual(participants, [sender]);
  });
});
