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

    mapping(uint => Property) private properties;
    uint public propertyIndex;

    event PropertyListed(uint indexed id, address indexed owner, uint price);  
    event PropertySold(uint indexed id, address indexed oldOwner, uint indexed newOwner, uint price);
    event PropertyReSold(uint indexed id, address indexed oldOwner, uint indexed newOwner, uint price);

    struct Review{
        uint productId;
        address reviewer;
        uint rating;
        string comment;
        uint likes;
    }

    mapping(uint => Review) private reviews;
    mapping(address => uint[]) private userReviews;
    mapping(uint => Product) private products;

    uint public reviewsCounter;

    event ReviewAdded(uint indexed productId, address indexed reviewer, uint indexed rating, string comment );
    event ReviewLiked(uint indexed productId, uint indexed reviewIndex, address indexed liker, uint indexed likes);
    

    struct Product{
        uint productId;
        uint totalRating;
        uint numOfReviews;
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