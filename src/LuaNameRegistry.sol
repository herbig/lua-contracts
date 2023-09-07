// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.21;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

interface Registrar {
    function allowName(string memory _name, uint256 _payment) external returns(bool);
}

contract LuaNameRegistry is Ownable {

    event NameRegistered(address indexed registrant, string indexed name);
    event NewRegistrar(address registrar);

    error AddressRegistered();
    error NameTaken();
    error NameNotAllowed();

    mapping(address => string) public addressToName;
    mapping(string => address) public nameToAddress;

    Registrar public registrar;

    constructor() {
        registrar = new InitialRegistrar();
    }

    function registerName(string memory _name) external payable {
        if (bytes(addressToName[msg.sender]).length != 0) revert AddressRegistered();
        if (nameToAddress[_name] != address(0)) revert NameTaken();
        if (!registrar.allowName(_name, msg.value)) revert NameNotAllowed();

        addressToName[msg.sender] = _name;
        nameToAddress[_name] = msg.sender;
        emit NameRegistered(msg.sender, _name);
    }

    function setRegistrar(Registrar _registrar) external onlyOwner {
        _registrar.allowName('test it', 0);
        registrar = _registrar;
        emit NewRegistrar(address(_registrar));
    }

    function withdraw(address payable _to) external onlyOwner {
        _to.transfer(address(this).balance);
    }
}

contract InitialRegistrar is Registrar {

    string[] public allowedCharacters = 
        ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
         'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
         'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
         'u', 'v', 'w', 'x', 'y', 'z', '_'];

    mapping(bytes1 => bool) internal allowedMap;

    constructor() {
        for (uint i = 0; i < allowedCharacters.length; i++)
            allowedMap[bytes(allowedCharacters[i])[0]] = true;
    }

    function allowName(string memory _name, uint256 _payment) external view returns(bool) {
        bytes memory nameBytes = bytes(_name);
        uint256 length = nameBytes.length;
        return 
            _payment == 0 &&
            length > 5 &&
            length < 17 &&
            _allCharactersAllowed(nameBytes, length);
    }

    function _allCharactersAllowed(bytes memory _nameBytes, uint256 _length) internal view returns (bool) {
        for (uint i; i < _length;) {
            if (!allowedMap[_nameBytes[i]]) return false;
            unchecked { ++i; }
        }
        return true;
    }
}