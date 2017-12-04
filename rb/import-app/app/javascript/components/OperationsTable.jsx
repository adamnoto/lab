import React from 'react'
import PropTypes from 'prop-types'
import { getOperationsForCompany, addOperationListener, removeOperationListener } from '../packs/api'
import { CSVLink } from 'react-csv'

class OperationTable extends React.Component {
  constructor(props) {
    super(props);
    this.operationsChangeListener = this.operationsChangeListener.bind(this);
    this.setFilter = this.setFilter.bind(this);
    this.downloadableData = this.downloadableData.bind(this)

    this.state = {
      operations: [],
      filterText: "",
      displayedData: []
    }

    addOperationListener(this.operationsChangeListener);
    getOperationsForCompany(this.props.companyId);
  }

  componentWillUnmount() {
    removeOperationListener(this.operationsChangeListener);
  }

  operationsChangeListener(operations) {
    if (operations) {
      if (operations[0] && operations[0].company_id == this.props.companyId) {
        this.setState({operations: operations, displayedData: operations});
      }
    } else { this.setState({operations: []}); }
  }

  downloadableData() {
    let rows = [['company', 'invoice_num', 'invoice_date',
      'operation_date', 'amount', 'reporter', 'notes',
      'status', 'kind']];
    this.state.displayedData.forEach((data) => {
      var row = [
        this.props.companyName,
        data.invoice_num,
        data.invoice_date,
        data.operation_date,
        data.amount,
        data.reporter,
        data.notes,
        data.status,
        data.kind
      ]
      rows.push(row);
    });
    return rows;
  }

  setFilter(e) {
    var filtext = e.target.value.toLowerCase();
    this.setState({filterText: filtext});

    if (filtext == "") {
      this.setState({displayedData: this.state.operations});
    } else {
      let data = [];
      this.state.operations.forEach((operation) => {
        var safestr = (data) => (String(data).toLowerCase());
        var passFilter = safestr(operation.invoice_num).includes(filtext) ||
          safestr(operation.reporter).includes(filtext) ||
          safestr(operation.status).includes(filtext) ||
          safestr(operation.kind).includes(filtext)
        if (passFilter) { data.push(operation); }
      });
      this.setState({displayedData: data});
    }
  }

  render() {
    return <div>
      <div className='row'>
        <div className='col-sm-10'>
          <input className='form-control' type='text' placeholder='Filter data' onChange={this.setFilter}/>
        </div>
        <div className='col-sm-2'>
          <CSVLink className='btn btn-dark'
            style={{width: '100%'}}
            filename={this.props.companyName}
            data={this.downloadableData()}>
            Download
          </CSVLink>
        </div>
      </div>
      <table className='table table-striped table-dark operation-table'>
        <thead>
          <tr>
            <td>Invoice Num.</td>
            <td>Invoice date</td>
            <td>Operation date</td>
            <td>Amount</td>
            <td>Reporter</td>
            <td>Notes</td>
            <td>Status</td>
            <td>Kind</td>
          </tr>
        </thead>
        <tbody>
          {this.state.displayedData.map(data => (
            <tr key={data.id}>
              <td style={{width: '5%'}}>{data.invoice_num}</td>
              <td style={{width: '10%'}}>{data.invoice_date}</td>
              <td style={{width: '15%'}}>{data.operation_date}</td>
              <td style={{width: '10%'}}>{data.amount}</td>
              <td style={{width: '20%'}}>{data.reporter}</td>
              <td style={{width: '25%'}}>{data.notes}</td>
              <td style={{width: '10%'}}>{data.status}</td>
              <td style={{width: '5%'}}>{data.kind}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>;
  }
}

OperationTable.propTypes = {
  companyId: PropTypes.number,
  companyName: PropTypes.string
}

export default OperationTable
