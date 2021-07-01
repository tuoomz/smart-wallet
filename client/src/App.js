import React, { Component } from "react";
import Dbank from "./contracts/dBank.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { loaded: false, kycAddress: "0x123", contractAddress: "", balance: 0 };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await new this.web3.eth.getAccounts();

      // Get the contract instance.
      this.networkId = await new this.web3.eth.net.getId();
      
      this.Dbank = await new this.web3.eth.Contract(
        Dbank.abi,
        Dbank.networks[this.networkId] && Dbank.networks[this.networkId].address,
      );       
      
      this.balance = await this.Dbank.methods.balance(this.accounts[0]).call();
      this.balanceInEth = this.web3.utils.fromWei(this.balance, "ether");

      this.setState({ loaded:true, address: this.Dbank._address, balance:this.balanceInEth});

    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };


  handleDeposit = async () => {
    this.Dbank.methods.deposit().send({
        from: this.accounts[0],
        gas: 2000000,
        gasPrice:1,
        value: this.web3.utils.toWei(this.refs.deposit.value, 'ether')
       });
  }


  handleWithdraw = async () => {
    this.Dbank.methods.withdraw().send({
        from: this.accounts[0]
       });
  }

  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Wallet</h1>
        <p>Contract Address: {this.state.address}</p>
        <p>Balance: {this.state.balance} eth <button type="button" onClick={this.handleWithdraw}>Withdraw</button></p>
        <input type="number" value="0.01" name="deposit" ref="deposit"/>
        <button type="button" onClick={this.handleDeposit}>Deposit</button>
      </div>
    );
  }
}

export default App;
