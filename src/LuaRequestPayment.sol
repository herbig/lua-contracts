// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.21;

contract LuaRequestPayment {

    event PaymentRequested(
        address indexed from, 
        address indexed to, 
        uint256 amount,
        bytes message
    );

    event PaymentFulfilled(
        address indexed from, 
        address indexed to, 
        uint256 amount,
        bytes message
    );

    struct Request {
        address from;
        address to;
        bytes input;
        uint256 value;
        uint256 timeStamp;
    }

    error SelfRequest();
    error InvalidAmount();

    mapping(address => Request[]) public requests;
    mapping(address => Request[]) public fulfillments;

    function getRequests(address _who) external view returns (Request[] memory) {
        return requests[_who];
    }

    function getFulfillments(address _who) external view returns (Request[] memory) {
        return fulfillments[_who];
    }

    function request(address _from, uint256 _amount, bytes memory _message) external {
        if (msg.sender == _from) revert SelfRequest();
        requests[_from].push(Request(_from, msg.sender, _message, _amount, block.timestamp));
        emit PaymentRequested(_from, msg.sender, _amount, _message);
    }

    function fulfill(uint256 _index) payable external {
        Request memory req = requests[msg.sender][_index];
        if (msg.value != req.value) revert InvalidAmount();

        req.timeStamp = block.timestamp;

        fulfillments[req.from].push(req);
        fulfillments[req.to].push(req);
        _clearRequest(_index);

        (bool success,) = req.to.call{value: req.value}(req.input);
        if (success) emit PaymentFulfilled(req.to, msg.sender, req.value, req.input);
    }

    function decline(uint256 _index) external {
        _clearRequest(_index);
    }

    function _clearRequest(uint256 _index) internal {
        uint256 lastIndex = requests[msg.sender].length - 1;
        Request memory last = requests[msg.sender][lastIndex];
        requests[msg.sender][_index] = last;
        delete requests[msg.sender][lastIndex];
    }
}