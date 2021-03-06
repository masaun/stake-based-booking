import React, { Component } from "react";
import getWeb3, { getGanacheWeb3, Web3 } from "../../utils/getWeb3";

import App from "../../App.js";

import { Typography, Grid, TextField } from '@material-ui/core';
import { ThemeProvider } from '@material-ui/styles';
import { theme } from '../../utils/theme';
import { Loader, Button, Card, Input, Heading, Table, Form, Flex, Box, Image, EthAddress } from 'rimble-ui';
import { zeppelinSolidityHotLoaderOptions } from '../../../config/webpack';

import styles from '../../App.module.scss';
//import './App.css';

import { contractAddressList } from '../../data/contractAddress/contractAddress.js'
import { tokenAddressList } from '../../data/tokenAddress/tokenAddress.js'
import { walletAddressList } from '../../data/walletAddress/walletAddress.js'


export default class StakeBasedBooking extends Component {
    constructor(props) {    
        super(props);

        this.state = {
            /////// Default state
            storageValue: 0,
            web3: null,
            accounts: null,
            route: window.location.pathname.replace("/", ""),
        };

        this._booking = this._booking.bind(this);
        this._approveCustomerComeShop = this._approveCustomerComeShop.bind(this);
        this._registerShop = this._registerLocalShop.bind(this);
        this._registerLocalOrganization = this._registerLocalOrganization.bind(this);
        this._distributePooledMoney = this._distributePooledMoney.bind(this);

        this.getTestData = this.getTestData.bind(this);
        this._getNumberOfDistributedAddress = this._getNumberOfDistributedAddress.bind(this);

        this.handleInputLocalShopName = this.handleInputLocalShopName.bind(this);
        this.handleInputLocalShopAddress = this.handleInputLocalShopAddress.bind(this);

        this.handleInputLocalOrganizationName = this.handleInputLocalOrganizationName.bind(this);
        this.handleInputLocalOrganizationAddress = this.handleInputLocalOrganizationAddress.bind(this);

        this.handleInputBookedShopId = this.handleInputBookedShopId.bind(this);
        this.handleInputBookedDateYear = this.handleInputBookedDateYear.bind(this);
        this.handleInputBookedDateMonth = this.handleInputBookedDateMonth.bind(this);
        this.handleInputBookedDateDay = this.handleInputBookedDateDay.bind(this);
        this.handleInputPayAmount = this.handleInputPayAmount.bind(this);

        this.handleInputApproveCustomerId = this.handleInputApproveCustomerId.bind(this);
    }

    handleInputLocalShopName({ target: { value } }) {
        this.setState({ valueOfLocalShopName: value });
    }

    handleInputLocalShopAddress({ target: { value } }) {
        this.setState({ valueOfLocalShopAddress: value });
    }

    handleInputLocalOrganizationName({ target: { value } }) {
        this.setState({ valueOfLocalOrganizationName: value });
    }

    handleInputLocalOrganizationAddress({ target: { value } }) {
        this.setState({ valueOfLocalOrganizationAddress: value });
    }

    handleInputBookedShopId({ target: { value } }) {
        this.setState({ valueOfBookedShopId: Number(value) });
    }

    handleInputBookedDateYear({ target: { value } }) {
        this.setState({ valueOfBookedDateYear: Number(value) });
    }

    handleInputBookedDateMonth({ target: { value } }) {
        this.setState({ valueOfBookedDateMonth: Number(value) });
    }

    handleInputBookedDateDay({ target: { value } }) {
        this.setState({ valueOfBookedDateDay: Number(value) });
    }

    handleInputPayAmount({ target: { value } }) {
        this.setState({ valueOfPayAmount: value });
    }

    handleInputApproveCustomerId({ target: { value } }) {
        this.setState({ valueOfApproveCustomerId: Number(value) });
    }


    /***
     * @dev - Main Functions
     **/
    _registerLocalShop = async () => {
        const { accounts, web3, stake_based_booking, stake_based_booking_address, valueOfLocalShopName, valueOfLocalShopAddress } = this.state;

        const _localShopName = valueOfLocalShopName;
        const _localShopAddress = valueOfLocalShopAddress;
        let res = await stake_based_booking.methods.registerLocalShop(_localShopName, _localShopAddress).send({ from: accounts[0] });
        console.log('=== response of registerLocalShop() ===', res);

        this.setState({ valueOfLocalShopName: '', valueOfLocalShopAddress: '' });
    } 

    _registerLocalOrganization = async () => {
        const { accounts, web3, stake_based_booking, stake_based_booking_address, valueOfLocalOrganizationName, valueOfLocalOrganizationAddress } = this.state;

        const _localOrganizationName = valueOfLocalOrganizationName;
        const _localOrganizationAddress = valueOfLocalOrganizationAddress;
        let res = await stake_based_booking.methods.registerLocalOrganization(_localOrganizationName, _localOrganizationAddress).send({ from: accounts[0] });
        console.log('=== response of registerLocalOrganization() ===', res);        

        this.setState({ valueOfLocalOrganizationName: '', valueOfLocalOrganizationAddress: '' });
    }

    _booking = async () => {
        const { accounts, web3, dai, stake_based_booking, stake_based_booking_address, valueOfBookedShopId, valueOfBookedDateYear, valueOfBookedDateMonth, valueOfBookedDateDay, valueOfPayAmount } = this.state;
        //const _amount = 1.152;  // 1.152 DAI
        //const payAmount = web3.utils.toWei(`${_amount}`, 'ether');
        const payAmount = web3.utils.toWei(valueOfPayAmount, 'ether');

        const _bookedShopId = valueOfBookedShopId;
        
        //const _bookedDate = 1587868230;  // April 26, 2020 2:30:30 AM (GMT)
        const _bookedDateYear = valueOfBookedDateYear;
        const _bookedDateMonth = valueOfBookedDateMonth;
        const _bookedDateDay = valueOfBookedDateDay;

        let res1 = await dai.methods.transfer(stake_based_booking_address, payAmount).send({ from: accounts[0] });
        console.log('=== response of transfer() ===', res2);

        let res2 = await stake_based_booking.methods.booking(payAmount, 
                                                             _bookedShopId, 
                                                             _bookedDateYear, 
                                                             _bookedDateMonth, 
                                                             _bookedDateDay).send({ from: accounts[0] });
        console.log('=== response of booking() ===', res2);

        this.setState({ valueOfPayAmount: '', 
                        valueOfBookedShopId: '', 
                        valueOfBookedDateYear: '', 
                        valueOfBookedDateMonth: '', 
                        valueOfBookedDateDay: '' });
    }

    _approveCustomerComeShop = async () => {
        const { accounts, web3, stake_based_booking, stake_based_booking_address, valueOfApproveCustomerId } = this.state;
        const _customerId = valueOfApproveCustomerId;
        let res = await stake_based_booking.methods.approveCustomerComeShop(_customerId).send({ from: accounts[0] });
        console.log('=== response of approveCustomerComeShop() ===', res);
        
        this.setState({ valueOfApproveCustomerId: '' });
    }    

    _distributePooledMoney = async () => {
        const { accounts, web3, stake_based_booking, stake_based_booking_address } = this.state;

        let res = await stake_based_booking.methods.distributePooledMoney().send({ from: accounts[0] });
        console.log('=== response of distributePooledMoney() ===', res); 
    }


    /***
     * @dev - Getter Functions
     **/
    getTimeframeToday = async () => {
        const { accounts, web3, stake_based_booking, stake_based_booking_address } = this.state;

        let res = await stake_based_booking.methods.getTimeframeToday().call();
        console.log('=== response of getTimeframeToday() ===', res);
    }

    _getCurrentCustomerId = async () => {
        const { accounts, web3, stake_based_booking, stake_based_booking_address } = this.state;

        let res = await stake_based_booking.methods.getCurrentCustomerId().call();
        console.log('=== response of getCurrentCustomerId() ===', res);
    }



    /***
     * @dev - Test Functions
     **/
    getTestData = async () => {
        const { accounts, web3, stake_based_booking, stake_based_booking_address } = this.state;

        const _currentAccount = accounts[0];
        let balanceOf1 = await stake_based_booking.methods.balanceOfCurrentAccount(_currentAccount).call();
        console.log('=== response of balanceOfCurrentAccount() / 1 ===', balanceOf1);
 
        //@dev - Transfer DAI from UserWallet to DAI-contract
        const _mintAmount = 1.05;  // Expected transferred value is 1.05 DAI（= 1050000000000000000 Wei）s
        let mintAmount = _mintAmount.toString();
        const decimals = 18;
        let _amount = web3.utils.toWei(mintAmount, 'ether');
        console.log('=== _amount ===', _amount);

        const _to = stake_based_booking_address;        
        let response = await stake_based_booking.methods.testFunc(_amount).send({ from: accounts[0] });
        console.log('=== response of testFunc() function ===', response);

        let balanceOf2 = await stake_based_booking.methods.balanceOfCurrentAccount(_currentAccount).call();
        console.log('=== response of balanceOfCurrentAccount() / 2 ===', balanceOf2);
    }

    transferDAIFromUserToContract = async () => {
        const { accounts, stake_based_booking, dai, stake_based_booking_address, web3 } = this.state;

        //@dev - Transfer DAI from UserWallet to DAI-contract
        const _mintAmount = 1.05;  // Expected transferred value is 1.05 DAI（= 1050000000000000000 Wei）s
        let mintAmount = _mintAmount.toString();
        const decimals = 18;
        let _amount = web3.utils.toWei(mintAmount, 'ether');
        console.log('=== _amount ===', _amount);
        const _to = stake_based_booking_address;
        let response1 = await dai.methods.transfer(_to, _amount).send({ from: accounts[0] });

        //@dev - Transfer DAI from DAI-contract to Logic-contract
        let response2 = await stake_based_booking.methods.transferDAIFromUserToContract(_amount).send({ from: accounts[0] });  // wei
        console.log('=== response of transferDAIFromUserToContract() function ===', response2);
    }

    _getNumberOfDistributedAddress = async () => {
        const { accounts, stake_based_booking, dai, stake_based_booking_address, web3 } = this.state;

        let res = await stake_based_booking.methods.getNumberOfDistributedAddress().call();  // wei
        console.log('=== response of getNumberOfDistributedAddress() function ===', res);
    }


    //////////////////////////////////// 
    ///// Refresh Values
    ////////////////////////////////////
    refreshValues = (instanceStakeBasedBooking) => {
        if (instanceStakeBasedBooking) {
          //console.log('refreshValues of instanceStakeBasedBooking');
        }
    }


    //////////////////////////////////// 
    ///// Ganache
    ////////////////////////////////////
    getGanacheAddresses = async () => {
        if (!this.ganacheProvider) {
            this.ganacheProvider = getGanacheWeb3();
        }
        if (this.ganacheProvider) {
            return await this.ganacheProvider.eth.getAccounts();
        }
        return [];
    }

    componentDidMount = async () => {
        const hotLoaderDisabled = zeppelinSolidityHotLoaderOptions.disabled;
     
        let StakeBasedBooking = {};
        let Dai = {};
        try {
          StakeBasedBooking = require("../../../../build/contracts/StakeBasedBooking.json");  // Load artifact-file of StakeBasedBooking
          Dai = require("../../../../build/contracts/Dai.json");    //@dev - DAI（Underlying asset）
        } catch (e) {
          console.log(e);
        }

        try {
          const isProd = process.env.NODE_ENV === 'production';
          if (!isProd) {
            // Get network provider and web3 instance.
            const web3 = await getWeb3();
            let ganacheAccounts = [];

            try {
              ganacheAccounts = await this.getGanacheAddresses();
            } catch (e) {
              console.log('Ganache is not running');
            }

            // Use web3 to get the user's accounts.
            const accounts = await web3.eth.getAccounts();
            // Get the contract instance.
            const networkId = await web3.eth.net.getId();
            const networkType = await web3.eth.net.getNetworkType();
            const isMetaMask = web3.currentProvider.isMetaMask;
            let balance = accounts.length > 0 ? await web3.eth.getBalance(accounts[0]): web3.utils.toWei('0');
            balance = web3.utils.fromWei(balance, 'ether');

            let instanceStakeBasedBooking = null;
            let deployedNetwork = null;

            // Create instance of contracts
            if (StakeBasedBooking.networks) {
              deployedNetwork = StakeBasedBooking.networks[networkId.toString()];
              if (deployedNetwork) {
                instanceStakeBasedBooking = new web3.eth.Contract(
                  StakeBasedBooking.abi,
                  deployedNetwork && deployedNetwork.address,
                );
                console.log('=== instanceStakeBasedBooking ===', instanceStakeBasedBooking);
              }
            }

            //@dev - Create instance of DAI-contract
            let instanceDai = null;
            let StakeBasedBookingAddress = StakeBasedBooking.networks[networkId.toString()].address;
            //let DaiAddress = "0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa"; //@dev - DAI（Kovan）
            let DaiAddress = "0xaD6D458402F60fD3Bd25163575031ACDce07538D";   //@dev - DAI（Ropsten）
            instanceDai = new web3.eth.Contract(
              Dai.abi,
              DaiAddress,
            );
            console.log('=== instanceDai ===', instanceDai);


            if (StakeBasedBooking) {
              // Set web3, accounts, and contract to the state, and then proceed with an
              // example of interacting with the contract's methods.
              this.setState({ 
                web3, 
                ganacheAccounts, 
                accounts, 
                balance, 
                networkId, 
                networkType, 
                hotLoaderDisabled,
                isMetaMask, 
                stake_based_booking: instanceStakeBasedBooking,
                dai: instanceDai,
                stake_based_booking_address: StakeBasedBookingAddress
              }, () => {
                this.refreshValues(
                  instanceStakeBasedBooking
                );
                setInterval(() => {
                  this.refreshValues(instanceStakeBasedBooking);
                }, 5000);
              });
            }
            else {
              this.setState({ web3, ganacheAccounts, accounts, balance, networkId, networkType, hotLoaderDisabled, isMetaMask });
            }
          }
        } catch (error) {
          // Catch any errors for any of the above operations.
          alert(
            `Failed to load web3, accounts, or contract. Check console for details.`,
          );
          console.error(error);
        }
    }


    render() {
        const { accounts, stake_based_booking } = this.state;

        return (
            <div className={styles.widgets}>
                <Grid container style={{ marginTop: 32 }}>
                    <Grid item xs={12}>
                        <Card width={"auto"} 
                              maxWidth={"960px"} 
                              mx={"auto"} 
                              my={5} 
                              p={20} 
                              borderColor={"#E8E8E8"}
                        >
                            <h4>Stake Based Booking</h4>

                            <Table>
                                <tr>
                                    <td>Local Shop Name</td>
                                    <td><Input type="text" placeholder="Please input Local Shop Name" value={this.state.valueOfLocalShopName} onChange={this.handleInputLocalShopName} /></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Local Shop Address</td>
                                    <td><Input type="text" placeholder="Please input Local Shop Address" value={this.state.valueOfLocalShopAddress} onChange={this.handleInputLocalShopAddress} /></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><Button size={'small'} mt={3} mb={2} onClick={this._registerLocalShop}> Register Local Shop </Button></td>
                                    <td></td>
                                </tr>
                            </Table>

                            <br />

                            <Table>
                                <tr>
                                    <td>Local Organization Name</td>
                                    <td><Input type="text" placeholder="Please input Local Organization Name" value={this.state.valueOfLocalOrganizationName} onChange={this.handleInputLocalOrganizationName} /></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Local Organization Address</td>
                                    <td><Input type="text" placeholder="Please input Local Organization Address" value={this.state.valueOfLocalOrganizationAddress} onChange={this.handleInputLocalOrganizationAddress} /></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><Button size={'small'} mt={3} mb={2} onClick={this._registerLocalOrganization}> Register Local Organization </Button></td>
                                    <td></td>
                                </tr>
                            </Table>

                            <br />

                            <h4>↓</h4>

                            <Table>
                                <tr>
                                    <td>Booked Shop Id</td>
                                    <td><Input type="text" placeholder="Please input Booked Shop Id" value={this.state.valueOfBookedShopId} onChange={this.handleInputBookedShopId} /></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>Booked Date<br />(YYYY/MM/DD)</td>
                                    <td><Input type="text" placeholder="Year (YYYY)" value={this.state.valueOfBookedDateYear} onChange={this.handleInputBookedDateYear} /></td>
                                    <td><Input type="text" placeholder="Month (MM)" value={this.state.valueOfBookedDateMonth} onChange={this.handleInputBookedDateMonth} /></td>
                                    <td><Input type="text" placeholder="Day (DD)" value={this.state.valueOfBookedDateDay} onChange={this.handleInputBookedDateDay} /></td>
                                </tr> 
                                <tr>
                                    <td>Pay Amount</td>
                                    <td><Input type="text" placeholder="Please input Pay Amount" value={this.state.valueOfPayAmount} onChange={this.handleInputPayAmount} /></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><Button size={'small'} mt={3} mb={2} onClick={this._booking}> Booking </Button></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </Table>
                            
                            <br />

                            <h4>↓</h4>

                            <Table>
                                <tr>
                                    <td>Customer Id</td>
                                    <td><Input type="text" placeholder="Please input Customer Id" value={this.state.valueOfApproveCustomerId} onChange={this.handleInputApproveCustomerId} /></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><Button size={'small'} mt={3} mb={2} onClick={this._approveCustomerComeShop}> Approve thing that Customer Come Shop </Button></td>
                                    <td></td>
                                </tr>
                            </Table>

                            <br />

                            <h4>↓</h4>

                            <Table>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><Button size={'small'} mt={3} mb={2} onClick={this._distributePooledMoney}> Distribute Pooled Money </Button></td>
                                    <td></td>
                                </tr>
                            </Table>
                        </Card>
                    </Grid>

                    <Grid item xs={4}>
                    </Grid>

                    <Grid item xs={4}>
                    </Grid>
                </Grid>

                <Grid container style={{ marginTop: 32 }}>
                    <Grid item xs={12}>
                        <Card width={"auto"} 
                              maxWidth={"1280px"} 
                              mx={"auto"} 
                              my={5} 
                              p={20} 
                              borderColor={"#E8E8E8"}
                        >
                            <h4>Testing Function</h4>

                            <Button size={'small'} mt={3} mb={2} onClick={this.getTestData}> Get Test Data </Button> <br />

                            <Button size={'small'} mt={3} mb={2} onClick={this.transferDAIFromUserToContract}> Transfer DAI From User To Contract </Button> <br />

                            <Button mainColor="DarkCyan" size={'small'} mt={3} mb={2} onClick={this.getTimeframeToday}> Get Timeframe Today </Button> <br />

                            <Button mainColor="DarkCyan" size={'small'} mt={3} mb={2} onClick={this._getCurrentCustomerId}> Get Current Customer Id </Button> <br />

                            <Button mainColor="DarkCyan" size={'small'} mt={3} mb={2} onClick={this._getNumberOfDistributedAddress}> Get Number Of Distributed Addresses </Button> <br />
                        </Card>
                    </Grid>

                    <Grid item xs={4}>
                    </Grid>

                    <Grid item xs={4}>
                    </Grid>
                </Grid>
            </div>
        );
    }

}
