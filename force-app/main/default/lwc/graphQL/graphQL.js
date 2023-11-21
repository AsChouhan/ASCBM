import { LightningElement, wire } from 'lwc';
import { gql, graphql } from "lightning/uiGraphQLApi";


export default class GraphQL extends LightningElement {
    @wire(graphql, {
        query: gql`
         query getcontacts {
           uiapi{
            query{
                Contact(first:5, orderBy:{Name:{order:ASC}}){
                    edges{
                        node{
                            Id
                            LastName
                            {
                            value
                            }
                        }
                    }
                }
            }
        }
    }
    `
    })
    graphql;

    get Contacts() {
        return this.graphql.data.uiapi.query.Contact.edges.map((edge) => ({
            Name: edge.node.LastName.value
        }));
    }
}