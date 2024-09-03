// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Encoding {
    // Transactions - Contract Deployment

    function combineString() public pure returns (string memory) {
        return string(abi.ecodePacked("Hi Mom!", "Miss you!")); // abi encode pack "Hi Mom!", "Miss you!" togather into bytes form and then we cast them to string back again
    }

    // globally available methods & units

    // 0.8.12 + we can use string.concat()
    // string.concat(stringA, stringB);

    // constract.sol --> solc compiler --> contract.abi -> ABI (Application Binary Interface) -> inputs and outputs ->  human readable and know how to interact with contract
    //                                 |-> contract.bin -> binary data -> push on blockchain

    function encodeNumber() public pure returns (bytes memory) {
        bytes memory number = abi.encode(1);
        return number;
    }

    function encodeString() public pure returns (bytes memory) {
        bytes memory someString = abi.encode("some string");
        return someString;
    }

    function encodeStringPacked() public pure returns (bytes memory) {
        bytes memory someString = abi.encodePacked("some string");
        return someString;
    }

    function encodeStringBytes() public pure returns (bytes memory) {
        bytes memory someString = bytes("some string");
        return someString;
    }

    function decodeString() public pure returns (string memory) {
        string memory someString = abi.decode(encodeString(), (string)); // decode into string
        return someString;
    }

    function multiEncode() public pure returns (bytes memory) {
        bytes memory someString = abi.encode("some string", "it's bigger!");
        return someString;
    }

    function multiDecode() public pure returns (string memory, string memory) {
        (string memory someString, string memory someOtherString) = abi.decode(
            multiEncode(),
            (string, string)
        );
        return (someString, someOtherString);
    }

    function multiEncodePacked() public pure returns (bytes memory) {
        bytes memory someString = abi.encodePacked(
            "some string",
            "it's bigger!"
        );
        return someString;
    }

    // this doesn't work
    function multiDecodePacked()
        public
        pure
        returns (string memory, string memory)
    {
        (string memory someString, string memory someOtherString) = abi.decode(
            multiEncodePacked(),
            (string)
        );
        return someString;
    }

    function multiStringCastPacked() public pure returns (string memory) {
        string memory someString = string(multiDecodePacked());
        return someString;
    }

    // Transactions - Function Call

    // 1. ABI -> just to know name of the function and input type to send function call
    // 2. Contract Address
    // How do we send transaction that call functions with just the data field populated?
    // How do we populate the data field?

    function withdraw(address recentWinner) public {
        (bool success, ) = recentWinner.call{value: address(this).balance}(""); // send money but don't pass any data keep data be empty
        require(success, "Transfer Failed");
    }
}
