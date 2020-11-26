//SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Management.sol";

contract Product is ERC721{

    address public producer;
    uint256 token_Id = 1;
    string public productName;
    Management private management;

    mapping(uint256 => address[]) internal itemProvenances;
    mapping(address => uint256[]) internal ownedItems;
    mapping(uint256 => uint256) internal ownedItemsIndex;
    mapping(address => bool) productHandlers;

    constructor(address _producer, string memory _productName, address managementAddress) public ERC721(_productName, "PRDT") {
        producer = _producer;
        productName = _productName;
        management = Management(managementAddress);
        management.addActorProduct(_producer, address(this), _productName);
        productHandlers[_producer] = true;
    }

    function exchangeProduct(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved");
        _transfer(from, to, tokenId);
        if(productHandlers[to] == false) {
            management.addActorProduct(to, address(this), productName);
            productHandlers[to] = true;
        }
        uint256 tokenIndex = ownedItemsIndex[tokenId];
        delete ownedItemsIndex[tokenId];
        uint256 lastIndex = (ownedItems[msg.sender].length) - 1;
        uint256 lastToken = ownedItems[msg.sender][lastIndex];
        ownedItems[msg.sender][tokenIndex] = lastToken;
        ownedItemsIndex[lastToken] = tokenIndex;
        ownedItems[msg.sender].pop();
        ownedItems[to].push(tokenId);
        ownedItemsIndex[tokenId] = (ownedItems[to].length) - 1;
        itemProvenances[tokenId].push(to);
    }

    function generateNewProduct() public virtual {
        require(msg.sender == producer, "Only producer can generate new product");
        _mint(producer, token_Id);
        itemProvenances[token_Id].push(producer);
        ownedItems[msg.sender].push(token_Id);
        uint256 len = ownedItems[msg.sender].length;
        ownedItemsIndex[token_Id] = len - 1;
        token_Id++;
    }

    function deleteProduct(uint256 tokenId) public {
        require(_isApprovedOrOwner(tx.origin, tokenId), "Caller is not owner nor approved");
        _burn(tokenId);
        uint256 tokenIndex = ownedItemsIndex[tokenId];
        delete ownedItemsIndex[tokenId];
        uint256 lastIndex = (ownedItems[tx.origin].length) - 1;
        uint256 lastToken = ownedItems[tx.origin][lastIndex];
        ownedItems[tx.origin][tokenIndex] = lastToken;
        ownedItemsIndex[lastToken] = tokenIndex;
        ownedItems[tx.origin].pop();
    }

    function getProductAmount(address actorAddress) public view returns(uint256) {
        return ownedItems[actorAddress].length;
    }

    function getActorProducts() public view returns (uint256[] memory) {
        return ownedItems[msg.sender];
    }

    function getProvenance(uint256 Id) public view returns (address[] memory) {
        return itemProvenances[Id];
    }
}

