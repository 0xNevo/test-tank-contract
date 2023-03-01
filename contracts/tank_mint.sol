// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract TankMint is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address contractOwner;
    bool gameStarted;
    uint8 playerCnt = 0;

    mapping( address => int256 ) profitPerWallet;

    event TankNFTMinted( address player, uint256 tokenId );
    event BettingStarted( address player, uint256 amount );
    event BettingEnded( address winner, uint256 rewardAmount );

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721( _name, _symbol ) {
        contractOwner = msg.sender;
    }

    function mintTankNFT ( string memory _tokenUri ) public returns ( uint256 _tokenId ) {
        _tokenIds.increment(  );

        uint256 tokenId = _tokenIds.current(  );

        _safeMint( msg.sender, tokenId );
        _setTokenURI( tokenId, _tokenUri );

        emit TankNFTMinted( msg.sender, tokenId );

        return tokenId;
    }

    function bettingEther ( uint256 _amount ) public payable returns ( bool status ) {
        require( msg.value >= _amount, "The payment is not enough!" );
        require( gameStarted == false, "The game is already started!" );
        require( playerCnt < 2, "Players are ready already!" );

        profitPerWallet[ msg.sender ] -= int256( _amount );
        playerCnt = playerCnt + 1;

        if( playerCnt == 2 ) gameStarted = true;

        emit BettingStarted( msg.sender, _amount );

        return true;
    }

    function sendRewardToWinner ( address _winner, uint256 _rewardAmount ) public returns ( bool status ) {
        require( address( this ).balance >= _rewardAmount, "The balance is not enough!" );
        require( gameStarted == true, "The game is not started yet!" );

        ( bool sent, ) = _winner.call{ value: _rewardAmount }( "" );
        require( sent, "Failed to send Ether" );

        profitPerWallet[ _winner ] += int256( _rewardAmount );
        gameStarted = false;
        playerCnt = 0;

        emit BettingEnded( _winner, _rewardAmount );

        return true;
    }
}