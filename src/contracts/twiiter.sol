// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract twittertweet{
    address public  owner;
    bool public pause;
    uint16 public  MAX_LENGHT = 280;
    event gettweetcreate(address author,uint256 id,string tweet,uint256 timestamp,uint256 likes);
    event eventliketweet(address likeuser,address author,uint256 id,uint256 likes);
    event eventdisliketweet(address dislikeuser,address author ,uint256 id,uint256 likes);


    constructor() {
        owner = msg.sender;
        pause = false;
    }

    modifier onlyowner(){
        require(msg.sender == owner,"only owner can write the tweet");
        _;

    }
    modifier checkpause(){
        require(pause == false,"contract is pause");
        _;
    }
    function pauseed() public onlyowner{
        // require(!pause,"contract is pause");
        pause = true;   
    }
    function unpause() public onlyowner{
        pause = false;

    }
    function changetweetlenght(uint16 CHANGE_TWEET_LENGHT) public checkpause {
        MAX_LENGHT = CHANGE_TWEET_LENGHT;

    }

    struct tweet{
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
        
    }
    mapping(address => tweet[]) public tweets;
    function createtweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_LENGHT,"the tweet content is too long");
        tweet memory newtweet = tweet({
            id:tweets[msg.sender].length,
            author:msg.sender,
            content:_tweet,
            timestamp:block.timestamp,
            likes:0
        });
        tweets[msg.sender].push(newtweet);
        emit gettweetcreate(newtweet.author, newtweet.id, newtweet.content, newtweet.timestamp, newtweet.likes);

    }

    function gettweet(uint256 _i) public view returns (tweet memory){
        return tweets[msg.sender][_i];
    }
    function getalltweet(address _owner) public view returns (tweet[] memory){
        return tweets[_owner];
    }
    function liketweet(address author,uint256 id) external{
        require(tweets[author][id].id==id,"the tweet is not found;");
        tweets[author][id].likes++;
        emit eventliketweet(msg.sender, author ,  id,tweets[author][id].likes);

    }
    function disliketweet( address author,uint256 id) external{
        require(tweets[author][id].id==id,"the tweet is not found");

        tweets[author][id].likes--;
        emit eventdisliketweet(msg.sender, author , id,tweets[author][id].likes);


    }
}


