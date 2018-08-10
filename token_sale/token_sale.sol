pragma solidity ^0.4.24;
import './IERC20Token.sol';
//https://programtheblockchain.com/posts/2018/02/02/writing-a-token-sale-contract/

//Subset of ERC20 functions.

contract TokenSale {
    IERC20Token public tokenContract;
    uint256 public price;
    address owner;
    uint256 tokensSold;
    
    event Sold(address buyer, uint256 amount);
    
    constructor(IERC20Token _token, uint256 _price) public {
        require(_price > 0);
        owner = msg.sender;
        tokenContract = _token;
        price = _price;
    }
    
    function safeMultiple(uint256 a, uint256 b) internal pure returns(uint256){
        if(a == 0){
            return 0;
        } else {
            uint256 c = a * b;
            assert(c/a == b);
            return c;
        }
    }
    
    function buyTokens(uint256 numberOfTokens) public payable{
        require(msg.value == safeMultiple(numberOfTokens, price));
        
        uint256 scaledAmount = safeMultiple(numberOfTokens, 
            uint256(10)**tokenContract.decimals());
        
        uint256 tokenContractBalance = tokenContract.balanceOf(this);
        
        require(tokenContractBalance >= scaledAmount);
        
        emit Sold(msg.sender, numberOfTokens);
        tokensSold += numberOfTokens;
        
        require(tokenContract.transfer(msg.sender, scaledAmount));
    }
    
    function endSale() public {
        require(msg.sender == owner);
        
        require(tokenContract.transfer(owner, tokenContract.balanceOf(this)));
        msg.sender.transfer(address(this).balance);
    }
    
    
}
