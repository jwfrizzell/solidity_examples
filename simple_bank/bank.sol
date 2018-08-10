pragma solidity ^0.4.24;

//https://programtheblockchain.com/posts/2018/01/05/writing-a-banking-contract/
contract Bank {
    mapping(address => uint256) public balanceOf;
    
    function deposit(uint256 _amount) public payable {
        require(_amount > 0);
        require(msg.value == _amount);
        balanceOf[msg.sender] += _amount;
    }
    
    function withdraw(uint256 _amount) public {
        require(balanceOf[msg.sender] >= _amount);
        balanceOf[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        
    }
}
