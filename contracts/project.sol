// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenizedArtPlatform {

    // Struct to hold the tokenized art details
    struct Art {
        uint256 artId;
        string title;
        string artist;
        string uri;  // URL or IPFS link to the digital art
        uint256 price;
        address payable owner;
    }

    mapping(uint256 => Art) public arts;
    uint256 public artCount;

    // Event for art listing
    event ArtListed(uint256 artId, string title, string artist, uint256 price);

    // Event for art sale
    event ArtSold(uint256 artId, address buyer, uint256 price);

    // Modifier to check if the sender is the owner of the art
    modifier onlyOwner(uint256 _artId) {
        require(msg.sender == arts[_artId].owner, "You are not the owner");
        _;
    }

    // Function to list new art
    function listArt(string memory _title, string memory _artist, string memory _uri, uint256 _price) public {
        artCount++;
        arts[artCount] = Art(artCount, _title, _artist, _uri, _price, payable(msg.sender));

        emit ArtListed(artCount, _title, _artist, _price);
    }

    // Function to buy art
    function buyArt(uint256 _artId) public payable {
        Art storage art = arts[_artId];
        require(msg.value == art.price, "Incorrect price");
        require(art.owner != msg.sender, "You already own this art");

        // Transfer the payment to the owner
        art.owner.transfer(msg.value);

        // Transfer ownership of the art
        art.owner = payable(msg.sender);

        emit ArtSold(_artId, msg.sender, art.price);
    }

    // Function to change art price (only for owner)
    function changeArtPrice(uint256 _artId, uint256 _newPrice) public onlyOwner(_artId) {
        arts[_artId].price = _newPrice;
    }

    // Function to get art details
    function getArtDetails(uint256 _artId) public view returns (string memory title, string memory artist, string memory uri, uint256 price, address owner) {
        Art memory art = arts[_artId];
        return (art.title, art.artist, art.uri, art.price, art.owner);
    }
}
