//SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;
pragma experimental ABIEncoderV2;

import "./Product.sol";
import "./ProductFactory.sol";
import "./MultiProduct.sol";
import "./MultiProductFactory.sol";

contract Management {

  address private registrar;
  address[] private actors;
  string[] private actorNames;
  mapping(address => bool) private actorRegistration;
  mapping(address => address[]) private actorProductAddresses;
  mapping(address => string[]) private actorProductNames;
  address[] private productAddresses;
  mapping(address => bool) private productRegistration;
  mapping(address => string) private productNames;
  mapping(address => string[]) private  producersProductNames;
  mapping(address => address[]) private  producersProductAddresses;
  mapping(address => string[]) private  recipeProductNames;
  mapping(address => address[]) private  recipeProductAddresses;

  ProductFactory productFactory;
  address productFactoryAddress;
  MultiProductFactory multiProductFactory;
  address multiProductFactoryAddress;

  constructor(address _productFactoryAddress, address _multiProductFactoryAddress) public {
    registrar = msg.sender;
    productFactory = ProductFactory(_productFactoryAddress);
    productFactoryAddress = _productFactoryAddress;
    multiProductFactory = MultiProductFactory(_multiProductFactoryAddress);
    multiProductFactoryAddress = _multiProductFactoryAddress;
  }

  function createProductContract(string memory productName) public {
    require(actorRegistration[msg.sender], "Only registered actors can create product contracts");
    address createdProductContractAddress = productFactory.createProduct(msg.sender, productName, address(this));
    productNames[createdProductContractAddress] = productName;
    //productRegistration[createdProductContractAddress] = true;
    producersProductNames[msg.sender].push(productName);
    producersProductAddresses[msg.sender].push(createdProductContractAddress);
  }

  function createMultiProductContract(string memory productName, address[] memory ingredients, uint256[] memory ingredientQuantities) public {
    require(actorRegistration[msg.sender], "Only registered actors can create product contracts");
    address createdMultiProductContractAddress = multiProductFactory.createMultiProduct(msg.sender, productName, address(this), ingredients, ingredientQuantities);
    productNames[createdMultiProductContractAddress] = productName;
    productRegistration[createdMultiProductContractAddress] = true;
    recipeProductNames[msg.sender].push(productName);
    recipeProductAddresses[msg.sender].push(createdMultiProductContractAddress);
  }

  function registerActor(address actorAddress, string memory actorName) public {
    require(msg.sender == registrar);
    actorRegistration[actorAddress] = true;
    actors.push(actorAddress);
    actorNames.push(actorName);
  }

  function addActorProduct(address actorAddress, address productContractAddress, string memory productName) public {
    require(productRegistration[productContractAddress]);
    actorProductAddresses[actorAddress].push(productContractAddress);
    actorProductNames[actorAddress].push(productName);
  }

  function getProducersProductAddresses(address actorAddress) public view returns(address[] memory) {
    return producersProductAddresses[actorAddress];
  }

  function getProducersProductNames(address actorAddress) public view returns(string[] memory) {
    return producersProductNames[actorAddress];
  }

  function getProductName(address productAddress) public view returns (string memory) {
    return productNames[productAddress];
  }

  function getActorProductNames(address actorAddress) public view returns (string[] memory) {
    return actorProductNames[actorAddress];
  }

  function getActorProductAddresses(address actorAddress) public view returns (address[] memory) {
    return actorProductAddresses[actorAddress];
  }

  function getRecipeProductNames(address actorAddress) public view returns (string[] memory) {
    return recipeProductNames[actorAddress];
  }

  function getRecipeProductAddresses(address actorAddress) public view returns (address[] memory) {
    return recipeProductAddresses[actorAddress];
  }

  function getActorNames() public view returns (string[] memory) {
    return actorNames;
  }

  function getActors() public view returns (address[] memory) {
      return actors;
  }
}


