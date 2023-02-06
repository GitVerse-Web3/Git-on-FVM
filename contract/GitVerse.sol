// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract GitVerseNFT is ERC1155, Ownable, Pausable, ERC1155Supply {
    using Counters for Counters.Counter;
    Counters.Counter public tokenIdCounter;

    uint public CREATE_PKG_PRICE = 0.0001 ether;
    uint public MINT_Price = 0.0001 ether;
    mapping(uint => string) public tokenURIMap;
    mapping(uint => address) public pkgOwnerMap;

    mapping(uint => uint) public depsCountMap; // tokenId => count
    mapping(uint => mapping(string => uint)) public depsVersionCountMap; // tokenId => version => count

    event UpsertPkg(
        uint indexed tokenId,
        address indexed createdBy,
        string indexed name,
        string version,
        string description,
        string CID
    );

    function upsertPkg(
        string[] memory pkgInfoArr, // name, version, description, CID, tokenId
        uint[] memory depsTokenIds,
        string[] memory depsVersions // 输入的是 depsTokenId 的 version 信息的 CID 即可，此 IPFS 文件存储了该版本的详细信息
    ) public payable whenNotPaused {
        require(msg.value >= CREATE_PKG_PRICE, "insufficient funds");

        address createdBy = _msgSender();
        uint tokenId = tokenIdCounter.current();
        if (pkgInfoArr.length > 4) {
            tokenId = str2uint(pkgInfoArr[4]);
            require(pkgOwnerMap[tokenId] == createdBy, "not pkg owner");
        } else {
            tokenIdCounter.increment();
            pkgOwnerMap[tokenId] = createdBy;
        }

        tokenURIMap[tokenId] = pkgInfoArr[3]; // CID
        uint lens = depsTokenIds.length;
        for (uint i = 0; i < lens; i++) {
            depsCountMap[depsTokenIds[i]]++;
            depsVersionCountMap[depsTokenIds[i]][depsVersions[i]]++;
        }
        emit UpsertPkg(
            tokenId,
            createdBy,
            pkgInfoArr[0],
            pkgInfoArr[1],
            pkgInfoArr[2],
            pkgInfoArr[3]
        );
    }

    function getList(
        uint start,
        uint limit
    )
        public
        view
        returns (
            string[] memory tokenURIs,
            uint[] memory totalSupplys,
            uint[] memory depsCounts
        )
    {
        uint lens = uint(tokenIdCounter._value - start);
        if (lens < limit) {
            limit = lens;
        }

        tokenURIs = new string[](limit);
        totalSupplys = new uint[](limit);
        depsCounts = new uint[](limit);

        for (uint i = 0; i < limit; i++) {
            tokenURIs[i] = tokenURIMap[start + i];
            totalSupplys[i] = totalSupply(start + i);
            depsCounts[i] = depsCountMap[start + i];
        }
    }

    event Mint(address indexed createdBy, uint indexed tokenId, uint amount);

    function mint(uint tokenId, uint amount) public payable whenNotPaused {
        require(bytes(tokenURIMap[tokenId]).length > 0, "token not create yet");
        require(msg.value >= MINT_Price * amount, "insufficient funds");

        address createdBy = _msgSender();

        _mint(createdBy, tokenId, amount, "");
    }

    /* solhint-disable func-visibility */
    constructor() ERC1155("") {
        _setURI("");
    }

    function str2uint(string memory numString) public pure returns (uint) {
        uint val = 0;
        bytes memory stringBytes = bytes(numString);
        for (uint i = 0; i < stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
            uint jval = uval - uint(0x30);

            val += (uint(jval) * (10 ** (exp - 1)));
        }
        return val;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function uri(
        uint tokenId
    ) public view virtual override returns (string memory) {
        string memory tokenURI = tokenURIMap[tokenId];
        return tokenURI;
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint[] memory ids,
        uint[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
