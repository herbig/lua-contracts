// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.21;

import {Test, console2} from "../lib/forge-std/src/Test.sol";
import {LuaNameRegistry, Registrar, InitialRegistrar} from "../src/LuaNameRegistry.sol";

contract LuaNameRegistryTest is Test {

    address owner = address(11);
    address rando = address(12);
    address anotherRando = address(13);

    LuaNameRegistry registry;

    function setUp() public {
        vm.prank(owner);
        registry = new LuaNameRegistry();
        vm.deal(rando, 1 ether);
        vm.startPrank(rando);
    }

    function test_Register() public {
        registry.registerName{value: 0 ether}("test_name");
        assertEq(registry.addressToName(rando), "test_name");
        assertEq(registry.nameToAddress("test_name"), rando);
    }

    function test_AlreadyRegisteredAddress() public {
        registry.registerName{value: 0 ether}("test_name");
        vm.expectRevert(LuaNameRegistry.AddressRegistered.selector);
        registry.registerName{value: 0 ether}("another");
    }

    function test_NameTaken() public {
        registry.registerName{value: 0 ether}("test_name");
        vm.expectRevert(LuaNameRegistry.NameTaken.selector);
        vm.startPrank(anotherRando);
        registry.registerName{value: 0 ether}("test_name");
    }

    function test_TooShort() public {
        vm.expectRevert(LuaNameRegistry.NameNotAllowed.selector);
        registry.registerName{value: 0 ether}("12345");
    }

    function test_NotTooShort() public {
        registry.registerName{value: 0 ether}("123456");
        assertEq(registry.addressToName(rando), "123456");
        assertEq(registry.nameToAddress("123456"), rando);
    }

    function test_TooLong() public {
        vm.expectRevert(LuaNameRegistry.NameNotAllowed.selector);
        registry.registerName{value: 0 ether}("this_is_seventeen");
    }

    function test_NotTooLong() public {
        registry.registerName{value: 0 ether}("this_is_sixteen_");
        assertEq(registry.addressToName(rando), "this_is_sixteen_");
        assertEq(registry.nameToAddress("this_is_sixteen_"), rando);
    }

    function test_NoInvalidCharacter() public {
        vm.expectRevert(LuaNameRegistry.NameNotAllowed.selector);
        registry.registerName{value: 0 ether}("jawesome!");
    }

    function test_NoEmojis() public {
        vm.expectRevert(LuaNameRegistry.NameNotAllowed.selector);
        registry.registerName{value: 0.0 ether}(unicode"12345🚀");
    }

    function test_CantPayEth() public {
        vm.expectRevert(LuaNameRegistry.NameNotAllowed.selector);
        registry.registerName{value: 0.1 ether}("test_name");
    }

    function test_OwnerCanWithdraw() public {
        // we *should* send eth and check that it got there
        // and can be reclaimed, but the initial registrar
        // doesn't allow for sending eth to the name registry
        // this is a standard withdraw function, however, so 
        // we're just checking that it's callable by the owner
        vm.stopPrank();
        vm.startPrank(owner);
        registry.withdraw(payable(owner));
    }

    function test_RandoCantWithdraw() public {
        vm.expectRevert("Ownable: caller is not the owner");
        registry.withdraw(payable(owner)); // rando is the caller here
    }

    function test_CanSetNewRegistrar() public {
        Registrar registrar = new InitialRegistrar();
        vm.stopPrank();
        vm.startPrank(owner);
        registry.setRegistrar(registrar);
        assertEq(address(registry.registrar()), address(registrar));
    }

    function test_RegistrarMustActuallyBeARegistrar() public {
        vm.stopPrank();
        vm.startPrank(owner);
        vm.expectRevert();
        registry.setRegistrar(Registrar(rando));
    }

    function test_RandoCantSetRegistrar() public {
        Registrar registrar = new InitialRegistrar();
        vm.expectRevert("Ownable: caller is not the owner");
        registry.setRegistrar(registrar);
    }
}
