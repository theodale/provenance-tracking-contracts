//SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;

import "./MultiProduct.sol";

contract MultiProductFactory {

  constructor() public {}

  function createMultiProduct(address producer, string memory productName, address managementAddress, address[] memory ingredients, uint256[] memory ingredientQuantities) public returns(address) {
    require(msg.sender == managementAddress);
    MultiProduct newMultiProduct = new MultiProduct(producer, productName, ingredients, ingredientQuantities, managementAddress);
    return address(newMultiProduct);
  }
}
