import React from "react"
import cssModules from "react-css-modules"
import style from "./style.css"

import { default as Ticker } from "../Ticker"

export class Home extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className={style.tickerColumns}>
        <Ticker socket={this.props.route.socket} symbol="BTC" />
        <Ticker socket={this.props.route.socket} symbol="TSLA" />
        <Ticker socket={this.props.route.socket} symbol="ETH" />
        <Ticker socket={this.props.route.socket} symbol="GOOG" />
        <Ticker socket={this.props.route.socket} symbol="LTC" />
        <Ticker socket={this.props.route.socket} symbol="AAPL" />
        <Ticker socket={this.props.route.socket} symbol="XRP" />
        <Ticker socket={this.props.route.socket} symbol="FB" />
        <Ticker socket={this.props.route.socket} symbol="BCH" />
        <Ticker socket={this.props.route.socket} symbol="GLD" />
      </div>
    )
  }
}

export default cssModules(Home, style)