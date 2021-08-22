pragma solidity ^0.6.0;

contract MyContract{
    //Array
    uint[] public uintArray = [1,2,3];//dummy array to test out arrays
    string[] public stringArray = ["one","two","three"];//just to test arrays of strings.
    string[] public values;
    
    //the addValue(..) function pushes the input string to the array values.
    function addValue(string memory _value) public{
        values.push(_value);
    }
    
    function valueCount() public view returns(uint){
        return values.length;
    }
    
    uint[][] public array2D = [[1,2],[5,9]];//array2D is just a dummy array to test out 2D lists.
     
     
    //Mapping
    mapping(uint=>string) public names;//names is a dummy mapping to test out mappings. :P
    mapping(uint=>Book) public books;
    mapping(address=>mapping(uint=>Book)) public myMapping;
    
    struct Book{
        string title;
        string Author;
    }
    
    constructor() public{
        names[1] = "alice";
        names[2] = "bruce";
        names[3] = "carl";
    }
    
    
    //the addBook(..) function takes an int, title and author and maps the int to the struct Book(string,author) in the mapping 'books'.
    function addBook(uint _id, string memory _title,string memory _author) public{
        books[_id] = Book(_title,_author);
    }
    
    
    //the addMyBook(..) function takes the address and the parameters of addBook(..) with the additional functionality of 
    //mapping the address of the user. myMapping is used here.
    function addMyBook(uint _id, string memory _title,string memory _author) public{
        myMapping[msg.sender][_id] = Book(_title,_author);
    }
    
}