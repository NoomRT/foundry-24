// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    MoodNft moodNft;

    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");
        // console.log(sadSvg);
        vm.startBroadcast();
        moodNft = new MoodNft(svgToImageURI(sadSvg), svgToImageURI(happySvg));
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function _baseURI() internal view returns (string memory) {
        return "data:application/json;base64,";
    }

    function svgUriToMetaUri(
        string memory svgImageURI
    ) external view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                moodNft.getNFTname(),
                                '", "description": "An NFT tht reflects the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
                                svgImageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
