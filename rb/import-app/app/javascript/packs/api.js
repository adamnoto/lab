import axios from 'axios';

let COMPANY_LISTENERS = [];
let OPERATION_LISTENERS = [];

export function addCompanyListener(func) {
  COMPANY_LISTENERS.push(func);
}

export function removeCompanyListener(func) {
  COMPANY_LISTENERS = COMPANY_LISTENERS.filter(item => item !== func);
}

export function addOperationListener(func) {
  OPERATION_LISTENERS.push(func);
}

export function removeOperationListener(func) {
  OPERATION_LISTENERS = OPERATION_LISTENERS.filter(item => item !== func);
}

export function getAllCompanies() {
  axios.get('/companies.json')
    .then((resp) => {
      COMPANY_LISTENERS.forEach((func) => {func(resp.data);});
    });
}

export function getOperationsForCompany(companyId) {
  axios.get('/operations.json?company_id=' + companyId)
    .then((resp) => {
      OPERATION_LISTENERS.forEach((func) => {func(resp.data);});
    });
}
