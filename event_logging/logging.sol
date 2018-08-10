pragma solidity ^0.4.24;
//https://programtheblockchain.com/posts/2018/01/24/logging-and-watching-solidity-events/
contract Counter {
    uint256 public count = 0;
    
    event Increment(address who);
    
    function increment() public {
        emit Increment(msg.sender);
        count += 1;
    }
}

contract MultiCounter {
    mapping(uint256 => uint256) public counts;
    
    event Increment(uint256 indexed which, address who);
    
    function increrment(uint256 _which) public {
        emit Increment(_which, msg.sender);
        counts[_which] += 1;
    }
}
