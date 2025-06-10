# Blockchain-Based Maritime Cargo Insurance Networks

A decentralized insurance platform built on the Stacks blockchain using Clarity smart contracts, specifically designed for maritime cargo insurance operations.

## Overview

This project implements a comprehensive maritime cargo insurance system that leverages blockchain technology to provide transparent, automated, and efficient insurance services for maritime cargo operations. The system consists of five interconnected smart contracts that handle the entire insurance lifecycle from provider verification to claim settlements.

## Smart Contracts Architecture

### 1. Insurer Verification Contract (`insurer-verification.clar`)
- **Purpose**: Validates and manages maritime insurance providers
- **Key Features**:
    - Insurer registration and verification
    - License validation
    - Reputation scoring
    - Regulatory compliance tracking

### 2. Risk Assessment Contract (`risk-assessment.clar`)
- **Purpose**: Assesses maritime cargo risks using predefined parameters
- **Key Features**:
    - Route risk evaluation
    - Cargo type risk analysis
    - Weather and seasonal risk factors
    - Historical data integration
    - Dynamic risk scoring

### 3. Policy Management Contract (`policy-management.clar`)
- **Purpose**: Manages maritime insurance policies throughout their lifecycle
- **Key Features**:
    - Policy creation and issuance
    - Premium calculation
    - Coverage terms management
    - Policy renewal and cancellation
    - Multi-party policy support

### 4. Claim Processing Contract (`claim-processing.clar`)
- **Purpose**: Processes maritime insurance claims efficiently
- **Key Features**:
    - Claim submission and validation
    - Evidence documentation
    - Automated claim assessment
    - Dispute resolution mechanisms
    - Claim status tracking

### 5. Settlement Coordination Contract (`settlement-coordination.clar`)
- **Purpose**: Coordinates insurance settlements between parties
- **Key Features**:
    - Multi-party settlement coordination
    - Automated payment distribution
    - Escrow functionality
    - Settlement verification
    - Transaction logging

## Key Benefits

- **Transparency**: All transactions and processes are recorded on the blockchain
- **Automation**: Smart contracts automate policy management and claim processing
- **Efficiency**: Reduced processing time and administrative overhead
- **Security**: Cryptographic security ensures data integrity
- **Cost-Effective**: Lower operational costs through automation
- **Global Access**: Borderless insurance services for international maritime trade

## Technical Stack

- **Blockchain**: Stacks Blockchain
- **Smart Contract Language**: Clarity
- **Testing Framework**: Vitest
- **Development Environment**: Clarinet (for local development)

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- Clarinet CLI
- Stacks Wallet for testing

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-org/maritime-cargo-insurance.git
cd maritime-cargo-insurance
```

2. Install dependencies:
```bash
npm install
```

3. Initialize Clarinet project:
```bash
clarinet new maritime-insurance
cd maritime-insurance
```

### Running Tests

Execute the test suite using Vitest:

```bash
npm test
```

Run specific test files:
```bash
npm test -- insurer-verification.test.js
npm test -- risk-assessment.test.js
npm test -- policy-management.test.js
npm test -- claim-processing.test.js
npm test -- settlement-coordination.test.js
```

### Deployment

1. Configure your deployment settings in `Clarinet.toml`
2. Deploy to testnet:
```bash
clarinet deploy --testnet
```

3. Deploy to mainnet:
```bash
clarinet deploy --mainnet
```

## Contract Interactions

### Insurer Registration
```clarity
(contract-call? .insurer-verification register-insurer 
  "Maritime Insurance Co" 
  "License-123456" 
  u1000000)
```

### Risk Assessment
```clarity
(contract-call? .risk-assessment assess-cargo-risk 
  "Shanghai-Rotterdam" 
  "Electronics" 
  u30)
```

### Policy Creation
```clarity
(contract-call? .policy-management create-policy 
  'SP1234...INSURER 
  u500000 
  u10000 
  u365)
```

### Claim Submission
```clarity
(contract-call? .claim-processing submit-claim 
  u1 
  u50000 
  "Cargo damaged during storm")
```

## API Documentation

Detailed API documentation for each contract function is available in the `/docs` directory:

- [Insurer Verification API](docs/insurer-verification-api.md)
- [Risk Assessment API](docs/risk-assessment-api.md)
- [Policy Management API](docs/policy-management-api.md)
- [Claim Processing API](docs/claim-processing-api.md)
- [Settlement Coordination API](docs/settlement-coordination-api.md)

## Testing Strategy

Our testing approach includes:

- **Unit Tests**: Individual contract function testing
- **Integration Tests**: Cross-contract interaction testing
- **Scenario Tests**: End-to-end workflow testing
- **Edge Case Tests**: Boundary condition and error handling tests

## Security Considerations

- All contracts implement proper access controls
- Input validation on all public functions
- Reentrancy protection where applicable
- Safe arithmetic operations to prevent overflow/underflow
- Regular security audits recommended

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Roadmap

- [ ] Phase 1: Core contract deployment
- [ ] Phase 2: Web interface development
- [ ] Phase 3: Mobile application
- [ ] Phase 4: Integration with IoT sensors
- [ ] Phase 5: AI-powered risk assessment
- [ ] Phase 6: Cross-chain compatibility

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:
- Create an issue in this repository
- Join our Discord community
- Email: support@maritime-insurance.blockchain

## Acknowledgments

- Stacks Foundation for blockchain infrastructure
- Maritime industry partners for domain expertise
- Open source community for tools and libraries

---

**Disclaimer**: This is experimental software. Use at your own risk. Always conduct thorough testing before deploying to mainnet.
