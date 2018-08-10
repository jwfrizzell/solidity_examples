pragma solidity ^0.4.24;
//https://programtheblockchain.com/posts/2018/01/30/writing-an-erc20-token-contract/

contract IERC20Token {
    string public name = 'IERC20Token';
    string public symbol = 'IER';
    uint256 public decimals = 18;
    uint256 public totalSupply = 1000000 * (uint256(10)**decimals);
    
    mapping(address => uint256) public balanceOf; //required.
    mapping(address => mapping(address => uint256)) public allowance; //required
    
    
    event Transfer(address indexed from, address indexed to, uint256 value); //required
    event Approval(address indexed owner, address indexed spender, uint256 value); //required
    
    constructor() public {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
        
    function transfer(address to, uint256 value) public returns(bool success){//required
        require(value > 0);
        require(balanceOf[msg.sender] >= value);
        
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        
        emit Transfer(msg.sender, to, value);
        return true;
    }   
    
    function approval(address spender, uint256 value) public returns(bool success){ //required
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 value) public returns(bool success){
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);
        
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        
        emit Transfer(from, to, value);
        return true;
    }
    
    
}
