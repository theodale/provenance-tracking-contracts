//SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;

import "./Product.sol";

contract MultiProduct is Product {

  address[] public ingredients; //addresses of ingredient contracts
  uint256[] public ingredientQuantities;
  mapping(uint256 => uint256[]) private ingredientIds; //multiproduct ID -> its ingredient's IDs

  constructor(address _producer, string memory _productName, address[] memory _ingredients, uint256[] memory _ingredientQuantities, address managementAddress) public Product(_producer,_productName, managementAddress) {
    ingredients = _ingredients;
    ingredientQuantities = _ingredientQuantities;
  }

  function getIngredientAddresses() public view returns(address[] memory) {
    return ingredients;
  }

  function getIngredientQuantities() public view returns(uint256[] memory) {
    return ingredientQuantities;
  }

  //producer creates a new multiproduct
  //takes ingredient IDs in order as input
  function generateMultiProduct(uint256[] memory _ingredientIds) public {

      require(msg.sender == producer, "Only producer can generate new product");

      //check if creator has sufficient ingredients
      for(uint256 i = 0; i < ingredients.length; i++){
        Product ingredient = Product(ingredients[i]);
        uint256 amountOwned = ingredient.getProductAmount(msg.sender);
        if(amountOwned < ingredientQuantities[i]) {
          revert("Lack required ingredients");
        }
      }

      //store ingredient IDs and delete creator's ingredient tokens
      uint256 idCounter = 0;
      for(uint256 i = 0; i < ingredients.length; i++){
        Product ingredient = Product(ingredients[i]);
        for(uint256 j = 0; j < ingredientQuantities[i]; j++) {
          uint256 deleteId = _ingredientIds[j + idCounter];
          ingredientIds[token_Id].push(deleteId);
          ingredient.deleteProduct(deleteId);
        }
        idCounter = idCounter + ingredientQuantities[i];
      }

      //generate new product
      _mint(producer, token_Id);
      itemProvenances[token_Id].push(producer);
      ownedItems[tx.origin].push(token_Id);
      uint256 len = ownedItems[tx.origin].length;
      ownedItemsIndex[token_Id] = len - 1;
      token_Id++;

    // revert("Use createMultiIngredientProduct()");
  }

  function generateNewProduct() public override {
    revert("Please use generateMultiProduct()");
  }

  function getIngredientIds(uint256 Id) public view returns (uint256[] memory) {
    return ingredientIds[Id];
  }
}

