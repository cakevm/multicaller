// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {ERC20} from "./mocks/ERC20.sol";
import {MultiCaller} from "./Interface.sol";
import {TestHelper} from "./Helper.sol";

contract MulticallerSwapStep2Test is Test, TestHelper {
    string[4] testname = [
        "1 UniswapV3Like UniswapV3Like",
        "1 UniswapV3Like UniswapV2Like",
        "1 UniswapV2Like UniswapV3Like",
        "1 UniswapV2Like UniswapV2Like"
    ];

    bytes[4] callsdata = [
        bytes(
            hex"28472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000002647ffc000000000000000002448ad599c3a0ff1de082011efddc58f1908eb6e6d8128acb0800000000000000000000000078787878787878787878787878787878787878780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016345785d8a0000000000000000000000000000fffd8963efd1fc6a506488495d951d5263988d2500000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000001687ffc000082002002006400e47bea39867e4169dbe237d55c8242a8f2fcdcc387128acb0800000000000000000000000078787878787878787878787878787878787878780000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000014a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000007ffc00000000000000000044c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2a9059cbb0000000000000000000000008ad599c3a0ff1de082011efddc58f1908eb6e6d8000000000000000000000000000000000000000000000000016345785d8a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        ),
        bytes(
            hex"28472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000002c47ffc000000000000000002a48ad599c3a0ff1de082011efddc58f1908eb6e6d8128acb0800000000000000000000000078787878787878787878787878787878787878780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016345785d8a0000000000000000000000000000fffd8963efd1fc6a506488495d951d5263988d2500000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000001dc7ffc00000000000200440044a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48a9059cbb000000000000000000000000397ff1542f962076d0bfe58ea045ffa2d347aca000000000000000000000000000000000000000000000000000000000000000007ffd0000000000020030004484f16ca0000000000000000000000000397ff1542f962076d0bfe58ea045ffa2d347aca000000000000000000000000000000000000000000000000000000000000000007ffc000000000082004400a4397ff1542f962076d0bfe58ea045ffa2d347aca0022c0d9f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000007878787878787878787878787878787878787878000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000007ffc00000000000000000044c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2a9059cbb0000000000000000000000008ad599c3a0ff1de082011efddc58f1908eb6e6d8000000000000000000000000000000000000000000000000016345785d8a00000000000000000000000000000000000000000000000000000000000000000000"
        ),
        bytes(
            hex"28472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000002947ffd0000000000000000004495b66162000000000000000000000000b4e16d0168e52d35cacd2c6185b44281ec28c9dc000000000000000000000000000000000000000000000000016345785d8a00007ffc00000000008200240224b4e16d0168e52d35cacd2c6185b44281ec28c9dc022c0d9f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007878787878787878787878787878787878787878000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001687ffc000082002002006400e47bea39867e4169dbe237d55c8242a8f2fcdcc387128acb0800000000000000000000000078787878787878787878787878787878787878780000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000014a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000007ffc00000000000000000044c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2a9059cbb000000000000000000000000b4e16d0168e52d35cacd2c6185b44281ec28c9dc000000000000000000000000000000000000000000000000016345785d8a0000000000000000000000000000000000000000000000000000000000000000000000000000"
        ),
        bytes(
            hex"28472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000002f47ffd0000000000000000004495b66162000000000000000000000000b4e16d0168e52d35cacd2c6185b44281ec28c9dc000000000000000000000000000000000000000000000000016345785d8a00007ffc00000000008200240284b4e16d0168e52d35cacd2c6185b44281ec28c9dc022c0d9f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007878787878787878787878787878787878787878000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001dc7ffc00000000000200440044a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48a9059cbb000000000000000000000000397ff1542f962076d0bfe58ea045ffa2d347aca000000000000000000000000000000000000000000000000000000000000000007ffd0000000000020030004484f16ca0000000000000000000000000397ff1542f962076d0bfe58ea045ffa2d347aca000000000000000000000000000000000000000000000000000000000000000007ffc000000000082004400a4397ff1542f962076d0bfe58ea045ffa2d347aca0022c0d9f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000007878787878787878787878787878787878787878000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000007ffc00000000000000000044c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2a9059cbb000000000000000000000000b4e16d0168e52d35cacd2c6185b44281ec28c9dc000000000000000000000000000000000000000000000000016345785d8a000000000000000000000000000000000000"
        )
    ];

    function get_call_data(uint256 i) internal returns (bytes memory) {
        return callsdata[i];
    }

    function get_test_name(uint256 i) internal returns (string memory) {
        return testname[i];
    }

    function test_combo1() public {
        for (uint256 i = 0; i < callsdata.length; i++) {
            uint256 gasLeft = gasleft();
            uint256 balanceBefore = weth.balanceOf(address(multicaller));
            (bool result, ) = address(multicaller).call(get_call_data(i));
            uint256 gasUsed = gasLeft - gasleft();
            uint256 balanceUsed = balanceBefore - weth.balanceOf(address(multicaller));
            console.log(i, result, get_test_name(i), balanceBefore);
            if (balanceUsed >= 0.1 ether || balanceUsed == 0 || gasUsed < 100000) {
                console.log(i, "failed");
            }
        }
    }

    function test_single() public {
        uint256 i = 0;
        uint256 gasLeft = gasleft();
        uint256 balanceBefore = weth.balanceOf(address(multicaller));
        (bool result, ) = address(multicaller).call(get_call_data(i));
        uint256 gasUsed = gasLeft - gasleft();
        uint256 balanceUsed = balanceBefore - weth.balanceOf(address(multicaller));
        console.log(i, result, get_test_name(i), balanceBefore);
    }

    function test_combo2() public {
        bytes[1] memory call_data = [
            //maverick
            bytes(
                hex"28472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000002b47ffd00000000000000000064f93a17160000000000000000000000009c2dc3d5ffcecf61312c5f4c00660695b32fb3d10000000000000000000000000000000000000000000000000de0b6b3a764000000000000000000000000000000000000000000000000000000000000000026ac7ffc000000000082002402249c2dc3d5ffcecf61312c5f4c00660695b32fb3d1022c0d9f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007878787878787878787878787878787878787878000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001687ffc000082002002006400e488e6a0c2ddd26feeb64f039a2c41296fcb3f5640128acb0800000000000000000000000078787878787878787878787878787878787878780000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000014a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000007ffc00000000000000000044c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2a9059cbb0000000000000000000000009c2dc3d5ffcecf61312c5f4c00660695b32fb3d10000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000000000000000000"
            )
        ];

        for (uint256 i = call_data.length; i > 0; i--) {
            uint256 gasLeft = gasleft();
            uint256 balanceBefore = weth.balanceOf(address(multicaller));
            (bool result, ) = address(multicaller).call(call_data[i - 1]);
            uint256 gasUsed = gasLeft - gasleft();
            uint256 balanceAfter = weth.balanceOf(address(multicaller));
            uint256 balanceUsed = balanceBefore - balanceAfter;
            console.log(i, gasUsed, balanceAfter);
            if (balanceUsed >= 0.001 ether || balanceUsed == 0 || gasUsed < 100000) {
                console.log(i, "failed");
            }
            assertEq(result, true);
        }
    }

    function test_combo3() public {
        bytes[1] memory call_data = [
            bytes(
                hex"28472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000007687ffc00000000000000000324787878787878787878787878787878787878787828472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000002d47ffd0000000000000000004495b661620000000000000000000000004a86c01d67965f8cb3d0aaa2c655705e64097c31000000000000000000000000000000000000000000000000114d0a7e6f3e34007ffc000000000082002402644a86c01d67965f8cb3d0aaa2c655705e64097c31022c0d9f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007878787878787878787878787878787878787878000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001ac7ffe000082000000000000240f2d719407fdbeff09d87557abb7232601fd9f2970a0823100000000000000000000000078787878787878787878787878787878787878787ffc000082002082006400e42dd35b4da6534230ff53048f7477f17f7f4e7a70128acb0800000000000000000000000078787878787878787878787878787878787878780000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000140f2d719407fdbeff09d87557abb7232601fd9f290000000000000000000000007ffc00000000000000000044c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2a9059cbb0000000000000000000000004a86c01d67965f8cb3d0aaa2c655705e64097c31000000000000000000000000000000000000000000000000114d0a7e6f3e340000000000000000000000000000000000000000000000000000000000000000007ffc00000000000000000404787878787878787878787878787878787878787828472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000003a47ffc00000000000000000384ebce363564fa8b55d85aaf681156087116b148db128acb080000000000000000000000007878787878787878787878787878787878787878000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ab4a3470000000000000000000000000fffd8963efd1fc6a506488495d951d5263988d2500000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000002bf7ffe00008200000000000024102c776ddb30c754ded4fdcc77a19230a60d4e4f70a0823100000000000000000000000078787878787878787878787878787878787878787ffc000082002082006400e42b2a82d50e6e9d5b95ca644b989f9b143ea9ede2128acb0800000000000000000000000078787878787878787878787878787878787878780000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000014102c776ddb30c754ded4fdcc77a19230a60d4e4f0000000000000000000000007ffb00000000000000000003082a007ffc000082002082006400e448da0965ab2d2cbf1c17c09cfb5cbe67ad5b1406128acb0800000000000000000000000078787878787878787878787878787878787878780000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000146b175474e89094c44da98b954eedeac495271d0f0000000000000000000000007ffc00000000000000000044dac17f958d2ee523a2206206994597c13d831ec7a9059cbb000000000000000000000000ebce363564fa8b55d85aaf681156087116b148db00000000000000000000000000000000000000000000000000000000ab4a34700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            )
        ];

        for (uint256 i = call_data.length; i > 0; i--) {
            uint256 gasLeft = gasleft();
            uint256 balanceBefore = weth.balanceOf(address(multicaller));
            (bool result, ) = address(multicaller).call(call_data[i - 1]);
            uint256 gasUsed = gasLeft - gasleft();
            uint256 balanceAfter = weth.balanceOf(address(multicaller));
            uint256 balanceUsed = uint256(balanceBefore) - uint256(balanceAfter);
            console.log(i, gasUsed, balanceUsed);
            console.log(balanceBefore, balanceAfter, balanceUsed);

            if (balanceUsed >= 0.001 ether || balanceUsed == 0 || gasUsed < 100000) {
                console.log(i, "failed");
            }
            assertEq(result, true);
        }
    }
}