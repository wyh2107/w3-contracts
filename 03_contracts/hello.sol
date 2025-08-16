// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {

    //映射：用于存储钱包地址以及对应的余额
    mapping(address => uint256) public balances;

    //数组记录存款top 3
    address[3] public top3Addresss;

    uint256[3] public top3Amounts;

    //管理员地址
    address public owner;

    //构造函数初始化管理员地址
    constructor() {
        owner = msg.sender;
    }

    //这有点不太懂？
    receive() external payable { 
        deposit();
    }

    //前置检测是否是管理员
    modifier checkOwner() {
        require(owner == msg.sender, "Not admin.");
        _;
    }

    //检查存款是否大于0
    modifier checkBalance() {
        require(msg.value > 0, "Deposit must be more than 0.");
        _;
    }

    //存款函数
    function deposit() public payable checkBalance {
        balances[msg.sender] += msg.value;
        updateTop3(msg.sender);
    }

    function updateTop3(address user) internal {
        uint256 amount = balances[user];
        for(uint i = 0; i < 3; i ++) {
            //有序的一个数组，从大到小的排列
            //如果遇到比amount小的就需要放到该索引位置，其他的后移
            if (amount > top3Amounts[i]) {
                for(uint j = 2; j > i; j --) {
                    top3Addresss[j] = top3Addresss[j - 1];
                    top3Amounts[j] = top3Amounts[j - 1];
                }
                top3Addresss[i] = user;
                top3Amounts[i] = amount;
                break;
            }
        }

    }

    //管理员提取钱包里所有的ETH
    function withdraw() public checkOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "Not enough ETH withdraw.");
        payable(owner).transfer(amount);

    }

    function getTop3() public view returns(address[3] memory, uint256[3] memory) {
        return (top3Addresss, top3Amounts);
    }




}