import React from 'react'
import PropTypes from 'prop-types'
import Company from './Company'
import { addCompanyListener, removeCompanyListener, getAllCompanies } from '../packs/api'

class OperationIndex extends React.Component {
  constructor(props) {
    super(props);
    this.companyListChangeListener = this.companyListChangeListener.bind(this);

    this.state = {
      companies: []
    }

    addCompanyListener(this.companyListChangeListener);
    getAllCompanies();
  }

  componentWillUnmount() {
    removeCompanyListener(this.companyListChangeListener);
  }

  companyListChangeListener(companies) {
    this.setState({companies: companies});
  }

  render() {
    return <div id='accordion' role='tablist'>
      {this.state.companies.map(data => (
        <Company key={data.comp.id}
          id={data.comp.id}
          name={data.comp.name}
          number_of_operations={data.comp.op.noops}
          number_of_accepted_operations={data.comp.op.opsacp}
          average_amount={data.comp.op.avgamt}
          highest_monthly_operation={data.comp.op.mohigh}/>
      ))}
    </div>
  }
}

OperationIndex.defaultProps = {
  companies: []
}

OperationIndex.propTypes = {
  companies: PropTypes.array
}

export default OperationIndex
