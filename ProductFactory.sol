//SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;

import "./Product.sol";

contract ProductFactory {

  constructor() public {}

  function createProduct(address producerAddress, string memory productName, address managementAddress) public returns(address) {
    require(msg.sender == managementAddress);
    Product newProduct = new Product(producerAddress, productName, managementAddress);
    return address(newProduct);
  }
}


