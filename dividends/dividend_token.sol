pragma solidity ^0.4.24;
//https://programtheblockchain.com/posts/2018/02/07/writing-a-simple-dividend-token-contract/
contract DividendToken{
    string public name = "DividendToken";
    string public symbol = "DTC";
    // This code assumes decimals is zero---do not change.
    uint8 public decimals = 0;   //  DO NOT CHANGE!
    uint256 public totalSupply = 1000000 * (uint256(10)**decimals);
    uint256 public dividendPerToken;
    
    
    mapping(address => uint256) public dividendBalanceOf;
    mapping(address => uint256) public dividendCreditedTo;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    
    constructor() public payable {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(this), msg.sender, totalSupply);
    }
    
    function update(address account) internal {
        uint256 owed = dividendPerToken - dividendCreditedTo[account];
        dividendBalanceOf[account] += balanceOf[account] *  owed;
        dividendCreditedTo[account] = dividendPerToken;
    }
    
    function transfer(address to, uint256 value) public returns(bool success){
        require(balanceOf[msg.sender] >= value);
        
        update(msg.sender);
        update(to);
        
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 value) public returns(bool success){
        require(balanceOf[from] >= value);
        require(allowance[from][msg.sender] >= value);
        
        update(from);
        update(to);
        
        balanceOf[from] -= value;
        balanceOf[to] += value;
        
        allowance[from][msg.sender] -= value;
        
        emit Transfer(from, to, value);
        return true;
    }
    
    function deposit() public payable{
        dividendPerToken += msg.value / totalSupply;
    }
    
    function withdraw() public {
        update(msg.sender);
        
        uint256 amount = dividendBalanceOf[msg.sender];
        dividendBalanceOf[msg.sender] = 0; 
        msg.sender.transfer(amount);
    }
    
    
}
