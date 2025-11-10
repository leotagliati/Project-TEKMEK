export class Order {
    constructor({
        id, userId, status, totalValue, createdAt, updatedAt
    }) {
        Object.assign(this, {
            id, userId, status, totalValue, createdAt, updatedAt
        })
    }
}