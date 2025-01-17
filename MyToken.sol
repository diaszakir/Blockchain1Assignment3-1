// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    // Structure to store transaction information
    struct Transaction {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }
    
    // Array to store all transactions
    Transaction[] public transactions;
    
    constructor() ERC20("AITUSynergyToken", "AST") Ownable(msg.sender) {
        // Mint initial supply of 2000 tokens
        // Note: ERC20 uses 18 decimals by default, so we multiply by 10^18
        _mint(msg.sender, 2000 * 10**18);
    }
    
    // Override transfer function to store transaction information
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        bool success = super.transfer(to, amount);
        if (success) {
            // Store transaction information
            transactions.push(Transaction({
                sender: msg.sender,
                receiver: to,
                amount: amount,
                timestamp: block.timestamp
            }));
        }
        return success;
    }
    
    // Override transferFrom function to store transaction information
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        bool success = super.transferFrom(from, to, amount);
        if (success) {
            // Store transaction information
            transactions.push(Transaction({
                sender: from,
                receiver: to,
                amount: amount,
                timestamp: block.timestamp
            }));
        }
        return success;
    }
    
    // Function to get the latest transaction timestamp in human-readable format
    function getLatestTransactionTime() public view returns (string memory) {
        require(transactions.length > 0, "No transactions yet");
        
        uint256 timestamp = transactions[transactions.length - 1].timestamp;
        
        // Convert Unix timestamp to human-readable format
        // This is a simple conversion - you might want to add more sophisticated formatting
        uint256 year = 1970;
        uint256 month = 1;
        uint256 day = 1;
        uint256 hour = 0;
        uint256 minute = 0;
        uint256 second = timestamp;
        
        // Calculate years
        year += second / 31536000;
        second = second % 31536000;
        
        // Calculate months (approximate)
        month += second / 2592000;
        second = second % 2592000;
        
        // Calculate days
        day += second / 86400;
        second = second % 86400;
        
        // Calculate hours
        hour = second / 3600;
        second = second % 3600;
        
        // Calculate minutes
        minute = second / 60;
        second = second % 60;
        
        return string(abi.encodePacked(
            toString(year), "-",
            toString(month), "-",
            toString(day), " ",
            toString(hour), ":",
            toString(minute), ":",
            toString(second)
        ));
    }
    
    // Function to get the latest transaction sender
    function getLatestTransactionSender() public view returns (address) {
        require(transactions.length > 0, "No transactions yet");
        return transactions[transactions.length - 1].sender;
    }
    
    // Function to get the latest transaction receiver
    function getLatestTransactionReceiver() public view returns (address) {
        require(transactions.length > 0, "No transactions yet");
        return transactions[transactions.length - 1].receiver;
    }
    
    // Helper function to convert uint to string
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}