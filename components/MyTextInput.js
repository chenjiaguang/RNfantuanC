import React, {Component} from 'react';
import {Platform, TextInput} from 'react-native';

class MyTextInput extends Component {
  shouldComponentUpdate(nextProps){
    return Platform.OS !== 'ios' || this.props.value === nextProps.value;
  }
  blur = () => {
    this.refs.input.blur()
  }
  render() {
    return <TextInput ref="input" {...this.props} />;
  }
};

export default MyTextInput;