// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract MyContract {

    struct Property{
        uint productId;
        address owner;
        uint price;
        string propertyName;
        string category;
        string images;
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
    event ReviewLiked(uint indexed productId, uint indexed reviewIndex, address indexed liker, uint likes);


    struct Product{
        uint productId;
        uint totalRating;
        uint numOfReviews;
    }

    //Errors
    error ListedPrice(string);
    error NotOwner(string);
    error InsufficientAmount(string);

    constructor() {}

    function listProperty(address owner, uint price, string memory _propertyName, string memory _category, string memory _images, string memory _propertyAddress, string memory _propertyDescription) external returns (uint){
        if(price < 0){
            revert ListedPrice("Price must be greater than 0");
        }
        uint productId = propertyIndex++;
        Property storage property = properties[productId];
        property.productId = productId;
        property.owner = owner;
        property.category = _category;
        property.images = _images;
        property.price = price;
        property.propertyAddress = _propertyAddress;
        property.propertyDescription = _propertyDescription;
        property.propertyName = _propertyName;

        emit PropertyListed(productId, owner, price);
        return productId;
    }

    function updateProperty(address owner, uint productId, string memory _propertyName, string memory _category, string memory _images, string memory _propertyAddress, string memory _propertyDescription ) external returns (uint){
        Property storage property = properties[productId];
        if(property.owner != owner){
            revert NotOwner("You not the owner of this property!");
        }

        property.category = _category;
        property.images = _images;
        property.propertyAddress = _propertyAddress;
        property.propertyDescription = _propertyDescription;
        property.propertyName = _propertyName;

        return productId;
    }

    function changePrice(address owner, uint productId, uint price) external returns (string memory){
        Property storage property = properties[productId];
        if(property.owner != owner){
            revert NotOwner("You not the owner of this property!");
        }
        property.price = price;

        return "property price has been updated!";

    }

    function buyProperty(uint id, address buyer) external payable {
        uint amountToPay = msg.value;
        if (amountToPay != properties[id].price) {
            revert InsufficientAmount("Insufficient Funds");
        }

        Property storage property = properties[id];

        (bool success, ) = payable(property.owner).call{value: amountToPay}("");
        if (success) {
            property.owner = buyer;
            emit PropertySold(id, buyer, buyer, amountToPay);
        }
    }

    function getAllProperties() public view returns(Property[] memory){
        uint itemCount = propertyIndex;
        uint currentIndex = 0;

        Property[] memory items = new Property[](itemCount);
        for (uint i = 0; i < itemCount ; i++){
            uint currentId = i + 1;

            Property storage currentItem = properties[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;
        } 
        return items;
    } 

    function getProperty(uint id) external view returns(uint,address,uint,string memory,string memory,string memory,string memory, string memory){
        Property memory property = properties[id];
        return (
            property.productId,
            property.owner,
            property.price,
            property.propertyName,
            property.category,
            property.images,
            property.propertyAddress,
            property.propertyDescription
        );
    }

    function getUserProperties(address user) external view returns (Property[] memory){
        uint totalItemCount = propertyIndex;
        uint itemCount = 0;
        uint currentIndex = 0;
        for(uint i=0; i < totalItemCount; i++){
            if(properties[i+1].owner == user){
                itemCount += 1;
            }

        }

        Property[] memory items = new Property[](itemCount);
        for(uint i = 0; i < totalItemCount; i++){
            if(properties[i+1].owner == user){
                uint currentId = i + 1;
                Property storage currentItem = properties[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }

        }
    }

    function addReview() external {}

    function getProductReviews() external view returns (Review[] memory){}

    function getUserReviews() external view returns (Review[] memory){}

    function likeReview() external{}

    function getHighestRatedProduct() external view returns (uint){}


}