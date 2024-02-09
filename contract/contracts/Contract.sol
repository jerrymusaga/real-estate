// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract MyContract {

    struct Property{
        uint productId;
        address owner;
        uint price;
        string propertyName;
        string category;
        string image;
        string propertyAddress;
        string propertyDescription;
        address[] reviewers;
        string[] reviews;

    }

    constructor() {}

    function listProperty() external returns (uint){

    }

    function updateProperty() external returns (uint){

    }

    function buyProperty() external payable {

    }

    function getAllProperties() public view returns(Property[] memory){

    } 

    function getProperty() external view returns(){}

    function getUserProperties() external view returns (Property[] memory){}

    function addReview() external {}

    function getProductReviews() external view returns (Review[] memory){}

    function getUserReviews() external view returns (Review[] memory){}

    function likeReview() external{}

    function getHighestRatedProduct() external view returns (uint){}


}