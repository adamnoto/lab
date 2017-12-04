import React from "react"
import PropTypes from "prop-types"
import OperationsTable from './OperationsTable'

class Company extends React.Component {
  componentDidMount() {
    let jQuery = jQuery || $;
    if (jQuery) {
      jQuery('[data-toggle="tooltip"]').tooltip()
    }
  }

  render () {
    return (
      <div id={"company" + this.props.id} className='company-accordion'>
        <div className='card'>
          <div className='card-header' role='tab' id={"heading" + this.props.id}>
            <h5 className='mb-0'>
              <a data-toggle='collapse'
                data-target={"#collapse" + this.props.id}
                href={"#collapse" + this.props.id}
                aria-expanded='true'>
                {this.props.name}
              </a>
              &nbsp;

              <div className='company-stat'>
                <span className='badge badge-primary'
                  data-toggle='tooltip' data-placement='bottom'
                  title='Number of operations'>
                  {this.props.number_of_operations}
                </span>&nbsp;
                <span className='badge badge-success'
                  data-toggle='tooltip' data-placement='bottom'
                  title='Accepted operations'>
                  {this.props.number_of_accepted_operations}
                </span>&nbsp;
                <span className='badge badge-secondary'
                  data-toggle='tooltip' data-placement='bottom'
                  title='Average amount'>
                  {this.props.average_amount}
                </span>&nbsp;
                <span className='badge badge-info'
                  data-toggle='tooltip' data-placement='bottom'
                  title='Highest monthly operation'>
                  {this.props.highest_monthly_operation}
                </span>
              </div>
            </h5>
          </div>

          <div id={"collapse" + this.props.id} className='collapse' role='tabpanel'>
            <div className='card-body'>
              <OperationsTable companyId={this.props.id} companyName={this.props.name}/>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

Company.propTypes = {
  id: PropTypes.number,
  name: PropTypes.string,
  number_of_operations: PropTypes.number,
  number_of_accepted_operations: PropTypes.number,
  average_amount: PropTypes.number,
  highest_monthly_operation: PropTypes.number
};

export default Company
