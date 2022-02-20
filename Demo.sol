// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.10 and less than 0.9.0
pragma solidity ^0.8.10;

contract Lottery {
    address public Manager;
    address payable[] public Player;

    constructor(){
        Manager=msg.sender;
    }

    receive() external payable {
        require(msg.value== 1 ether);
        Player.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender==Manager);
        return address(this).balance; 
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, Player.length)));
    }

    function getWinner() public {
        require(msg.sender==Manager);
        uint r=random();
        uint index = r % Player.length;
        address payable winner;
        winner = Player[index];
        winner.transfer(getBalance());
        Player = new address payable[](0);
    }

}
