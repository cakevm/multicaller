// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/ERC20.sol";
import "../src/interfaces/dydx/ISoloMargin.sol";
import "./Interface.sol";
import "./Helper.sol";


contract MulticallerSwapStep5Test is Test {
    MultiCaller public multicaller;
    ERC20 public weth;
    ERC20 public usdt;
    ERC20 public erc20Mock;
    ERC20 public erc20Mock2;
 
    function setUp() public {
        erc20Mock = new ERC20();
        erc20Mock2 = new ERC20();

        multicaller = MultiCaller(HuffDeployer.deploy("Multicaller"));
        
        console.log("Multicaller:", address(multicaller));
        vm.deal(address(multicaller), 0.5 ether);

        weth = ERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        vm.prank(0x8EB8a3b98659Cce290402893d0123abb75E3ab28);
        weth.transfer(address(multicaller), 1.0 ether);

        usdt = ERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        vm.prank(0xF977814e90dA44bFA03b6295A0616a897441aceC);
        usdt.transfer(address(multicaller), 1_000_000_000); // 1k


        vm.startPrank(Operator,Operator);



    }


 
  function test_multiswap() public {
        bytes[1] memory call_data = [
bytes(hex"28472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000007687ffc0000000000000000032400000000003d71e9fc20fdeb46fb86afbbee477228472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000002d47ffd0000000000000000004495b661620000000000000000000000004a86c01d67965f8cb3d0aaa2c655705e64097c31000000000000000000000000000000000000000000000000114d0a7e6f3e34007ffc000000000082002402644a86c01d67965f8cb3d0aaa2c655705e64097c31022c0d9f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003d71e9fc20fdeb46fb86afbbee4772000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001ac7ffe000082000000000000240f2d719407fdbeff09d87557abb7232601fd9f2970a0823100000000000000000000000000000000003d71e9fc20fdeb46fb86afbbee47727ffc000082002082006400e42dd35b4da6534230ff53048f7477f17f7f4e7a70128acb0800000000000000000000000000000000003d71e9fc20fdeb46fb86afbbee47720000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000140f2d719407fdbeff09d87557abb7232601fd9f290000000000000000000000007ffc00000000000000000044c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2a9059cbb0000000000000000000000004a86c01d67965f8cb3d0aaa2c655705e64097c31000000000000000000000000000000000000000000000000114d0a7e6f3e340000000000000000000000000000000000000000000000000000000000000000007ffc0000000000000000040400000000003d71e9fc20fdeb46fb86afbbee477228472417000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000003a47ffc0000000000000000038448da0965ab2d2cbf1c17c09cfb5cbe67ad5b1406128acb0800000000000000000000000000000000003d71e9fc20fdeb46fb86afbbee4772000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000009cf7ae36643375961000000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000002bf7ffe00008200000000000024dac17f958d2ee523a2206206994597c13d831ec770a0823100000000000000000000000000000000003d71e9fc20fdeb46fb86afbbee47727ffc000082000082006400e4ebce363564fa8b55d85aaf681156087116b148db128acb0800000000000000000000000000000000003d71e9fc20fdeb46fb86afbbee477200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fffd8963efd1fc6a506488495d951d5263988d2500000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000014dac17f958d2ee523a2206206994597c13d831ec70000000000000000000000007ffb00000000000000000003082a007ffc000082002082006400e42b2a82d50e6e9d5b95ca644b989f9b143ea9ede2128acb0800000000000000000000000000000000003d71e9fc20fdeb46fb86afbbee47720000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000276a400000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000014102c776ddb30c754ded4fdcc77a19230a60d4e4f0000000000000000000000007ffc000000000000000000446b175474e89094c44da98b954eedeac495271d0fa9059cbb00000000000000000000000048da0965ab2d2cbf1c17c09cfb5cbe67ad5b140600000000000000000000000000000000000000000000009cf7ae3664337596100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
       ];

        for( uint256 i = call_data.length ; i > 0 ; i--) {
            uint256 gasLeft = gasleft();
            uint256 balanceBefore = weth.balanceOf(address(multicaller));
            (bool result, ) = address(multicaller).call( call_data[i-1]);
            uint256 gasUsed = gasLeft - gasleft();
            uint256 balanceAfter = weth.balanceOf(address(multicaller));
            //uint256 balanceUsed = uint256(balanceAfter) - uint256(balanceBefore);
            //console.log(i, gasUsed, balanceAfter - balanceBefore);
            console.log(balanceBefore,balanceAfter);

            //if( balanceUsed >= 0.001 ether ) {
            //    console.log(i,"failed");
            //}
            assertEq(result, true);
        }

    }



}


