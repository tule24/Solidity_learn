// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./MultiSigWallet.sol";
contract MultiSigFactory {

    MultiSigWallet[] public multiSigWalletInstances;

    mapping(address => mapping(address => bool)) public ownerWallets;

    event WalletCreated(address createdBy, address newWalletContractAddress, address[] owners, uint256 required);

    function createNewWallet(address[] memory _owners, uint256 _required) public {
        MultiSigWallet newMultiSigWalletContract = new MultiSigWallet(_owners,  _required);
        multiSigWalletInstances.push(newMultiSigWalletContract);
        for (uint i; i < _owners.length; i++){
            ownerWallets[_owners[i]][address(newMultiSigWalletContract)] = true;
        }
        emit WalletCreated(msg.sender, address(newMultiSigWalletContract), _owners, _required);
    }
}