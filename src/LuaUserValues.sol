// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.21;

contract LuaUserValues {

    event ValueUpdated(address indexed user, string key, string value);

    error UnmatchedArrays();

    /** user address to their own mapping of key/value pairs */
    mapping(address => mapping(string => string)) public values;

    function updateValue(string memory _key, string memory _value) external {
        _updateValue(_key, _value);
    }
    
    function updateValues(string[] memory _keys, string[] memory _values) external {
        if (_keys.length != _values.length)
            revert UnmatchedArrays();

        for (uint256 i; i < _keys.length;) {
             _updateValue(_keys[i], _values[i]);
            unchecked {
                ++i;
            }
        }
    }

    function _updateValue(string memory _key, string memory _value) internal {
        values[msg.sender][_key] = _value;
        emit ValueUpdated(msg.sender, _key, _value);
    }
}