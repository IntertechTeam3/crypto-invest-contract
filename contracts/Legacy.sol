// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Legacy {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Child {
        address addresses;
        string firstName;
        string lastName;
        uint256 balance;
        uint256 age;
        uint256 dateOfBirthTimeStamp;
        uint256 accessDateTimeStamp;
    }

    struct Parent {
        address addresses;
        string firstName;
        string lastName;
        address[] childrensAddress;
    }

    enum Roles {
        parent,
        child,
        admin,
        unregistered
    }

    mapping(address => Parent) public parentsMap;
    mapping(address => Child) public childrenMap;

    uint256 balanceAccessAge = 18;
    address[] parentAddress;
    address[] childAddress;

    modifier userCheck(address _address) {
        require(
            Roles.unregistered == addressControl(_address),
            "Kullanici Kayitli"
        );
        _;
    }

    function addParent(string memory _firstName, string memory _lastName)
        public
        userCheck(msg.sender)
    {
        Parent storage parent = parentsMap[msg.sender];
        parent.addresses = msg.sender;
        parent.firstName = _firstName;
        parent.lastName = _lastName;
    }

    function addChild(
        address _address,
        string memory _firstName,
        string memory _lastName,
        uint256 _dateOfBirthTimeStamp,
        uint256 _accessDateTimeStamp
    ) public userCheck(_address) {
        Child storage child = childrenMap[_address];
        child.addresses = _address;
        child.firstName = _firstName;
        child.lastName = _lastName;
        child.dateOfBirthTimeStamp = _dateOfBirthTimeStamp;
        child.accessDateTimeStamp = _accessDateTimeStamp;

        Parent storage parent = parentsMap[msg.sender];
        parent.childrensAddress.push(_address);
    }

    function addressControl(address _address) public view returns (Roles) {
        if (_address == owner) return Roles.admin;

        Parent storage parent = parentsMap[_address];
        if (parent.addresses == _address) return Roles.parent;

        Child storage child = childrenMap[_address];
        if (child.addresses == _address) return Roles.child;

        return Roles.unregistered;
    }

    function getParent() public view returns (Parent memory) {
        return parentsMap[msg.sender];
    }

    function getChild(address _adres) public view returns (Child memory) {
        return childrenMap[_adres];
    }

    function getChildsFromParent() public view returns (Child[] memory) {
        uint256 len = parentsMap[msg.sender].childrensAddress.length;
        Child[] memory childsFromParent = new Child[](len);
        for (uint8 i = 0; i < len; i++) {
            childsFromParent[i] = childrenMap[
                parentsMap[msg.sender].childrensAddress[i]
            ];
        }
        return childsFromParent;
    }
}
