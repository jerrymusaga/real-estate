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
    event PropertySold(uint indexed id, address indexed oldOwner, address indexed newOwner, uint price);
    event PropertyReSold(uint indexed id, address indexed oldOwner, uint indexed newOwner, uint price);

    struct Review{
        uint productId;
        address reviewer;
        uint rating;
        string comment;
        uint likes;
    }

    mapping(uint => Review[]) private reviews;
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
    error RatingError(string);

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
            emit PropertySold(id, property.owner ,buyer, amountToPay);
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
        return items;
    }

    function addReview(
        uint productId,
        uint rating,
        string calldata comment,
        address user
    ) external {
        if (rating > 5 || rating < 1) {
            revert RatingError("Rating must be between 1 and 5");
        }
        Property storage property = properties[productId];
        property.reviewers.push(user);
        property.reviews.push(comment);

        reviews[productId].push(Review(productId, user, rating, comment, 0));
        userReviews[user].push(productId);
        products[productId].totalRating += rating;
        products[productId].numOfReviews++;

        emit ReviewAdded(productId, user, rating, comment);
        reviewsCounter++;
    }

    function getProductReviews(uint productId) external view returns (Review[] memory){
        return reviews[productId];
    }

    function getUserReviews(address user) external view returns (Review[] memory){
        uint totalReviews = userReviews[user].length;
        Review[] memory userProductReviews = new Review[](totalReviews);
        for(uint i = 0; i < totalReviews; i++){
            uint productId = userReviews[user][i];
            Review[] memory productReviews = reviews[productId];

            for(uint j = 0; j < productReviews.length; j++){
                if(productReviews[j].reviewer == user){
                    userProductReviews[i] = productReviews[j];
                }
            }
        }
        return userProductReviews;
    }

    function likeReview(uint productId, uint reviewIndex, address user) external{
        Review storage review = reviews[productId][reviewIndex];
        review.likes++;
        emit ReviewLiked(productId, reviewIndex, user, review.likes);
    }

    function getHighestRatedProduct() external view returns (uint){
        uint highestRating = 0;
        uint highestRatedProductId = 0;

        for(uint i = 0; i < reviewsCounter; i++){
            uint productId = i + 1;
            if(products[productId].numOfReviews > 0){
                uint avgRating = products[productId].totalRating / products[productId].numOfReviews;
                if(avgRating > highestRating){
                    highestRating = avgRating;
                    highestRatedProductId = productId;
                }
            }
        }
        return highestRatedProductId;
    }


}