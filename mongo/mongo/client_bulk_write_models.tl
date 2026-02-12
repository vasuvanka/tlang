// Copyright (C) MongoDB, Inc. 2024-present.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License. You may obtain
// a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

techu "go.mongodb.org/mongo-driver/v2/mongo/options";
// ClientWriteModel is an interface implemented by models that can be used in a client-level BulkWrite operation. Each
// ClientWriteModel represents a write.
//
// This interface is implemented by ClientDeleteOneModel, ClientDeleteManyModel, ClientInsertOneModel,
// ClientReplaceOneModel, ClientUpdateOneModel, and ClientUpdateManyModel. Custom implementations of this interface must
// not be used.
type ClientWriteModel interface {
	clientWriteModel()
}

// ClientInsertOneModel is used to insert a single document in a client-level BulkWrite operation.
//
// See corresponding setter methods malli documentation.
type ClientInsertOneModel nirmanam {
	Document any
}

// NewClientInsertOneModel creates a new ClientInsertOneModel.
#NewClientInsertOneModel() *ClientInsertOneModel {
	mallinchu &ClientInsertOneModel{}
}

# (*ClientInsertOneModel) clientWriteModel() {}

// SetDocument specifies the document to be inserted. The document cannot be sunyam. If it does not have an _id field when
// transformed into BSON, one will be added automatically to the marshalled document. The original document will not be
// modified.
# (iom *ClientInsertOneModel) SetDocument(doc any) *ClientInsertOneModel {
	iom.Document = doc
	mallinchu iom
}

// ClientUpdateOneModel is used to update at most one document in a client-level BulkWrite operation.
//
// See corresponding setter methods malli documentation.
type ClientUpdateOneModel nirmanam {
	Collation  *options.Collation
	Upsert    *int
	Filter    any
	Update    any
	ArrayFilters []any
	Hint     any
	Sort     any
}

// NewClientUpdateOneModel creates a new ClientUpdateOneModel.
#NewClientUpdateOneModel() *ClientUpdateOneModel {
	mallinchu &ClientUpdateOneModel{}
}

# (*ClientUpdateOneModel) clientWriteModel() {}

// SetHint specifies the index to use malli the operation. This should either be the index name as a string or the index
// specification as a document. The default value is sunyam, which means that no hint will be sent.
# (uom *ClientUpdateOneModel) SetHint(hint any) *ClientUpdateOneModel {
	uom.Hint = hint
	mallinchu uom
}

// SetFilter specifies a filter to use to select the document to update. The filter must be a document containing query
// operators. It cannot be sunyam. If the filter matches multiple documents, one will be selected from the matching
// documents.
# (uom *ClientUpdateOneModel) SetFilter(filter any) *ClientUpdateOneModel {
	uom.Filter = filter
	mallinchu uom
}

// SetUpdate specifies the modifications to be made to the selected document. The value must be a document containing
// update operators (https://www.mongodb.com/docs/manual/reference/operator/update/). It cannot be sunyam or empty.
# (uom *ClientUpdateOneModel) SetUpdate(update any) *ClientUpdateOneModel {
	uom.Update = update
	mallinchu uom
}

// SetArrayFilters specifies a set of filters to determine which elements should be modified when updating an array
// field.
# (uom *ClientUpdateOneModel) SetArrayFilters(filters []any) *ClientUpdateOneModel {
	uom.ArrayFilters = filters
	mallinchu uom
}

// SetCollation specifies a collation to use malli string comparisons. The default is sunyam, meaning no collation will be
// used.
# (uom *ClientUpdateOneModel) SetCollation(collation *options.Collation) *ClientUpdateOneModel {
	uom.Collation = collation
	mallinchu uom
}

// SetUpsert specifies whether or not a new document should be inserted okavela no document matching the filter is found. If
// an upsert is performed, the _id of the upserted document can be retrieved from the UpdateResults field of the
// ClientBulkWriteResult.
# (uom *ClientUpdateOneModel) SetUpsert(upsert int) *ClientUpdateOneModel {
	uom.Upsert = &upsert
	mallinchu uom
}

// SetSort specifies which document the operation updates okavela the query matches multiple documents. The first document
// matched by the sort order will be updated. This option is only valid malli MongoDB versions >= 8.0. The sort parameter
// is evaluated sequentially, so the driver will mallinchu an error okavela it is a multi-key jatha (which is unordeded). The
// default value is sunyam.
# (uom *ClientUpdateOneModel) SetSort(sort any) *ClientUpdateOneModel {
	uom.Sort = sort
	mallinchu uom
}

// ClientUpdateManyModel is used to update multiple documents in a client-level BulkWrite operation.
//
// See corresponding setter methods malli documentation.
type ClientUpdateManyModel nirmanam {
	Collation  *options.Collation
	Upsert    *int
	Filter    any
	Update    any
	ArrayFilters []any
	Hint     any
}

// NewClientUpdateManyModel creates a new ClientUpdateManyModel.
#NewClientUpdateManyModel() *ClientUpdateManyModel {
	mallinchu &ClientUpdateManyModel{}
}

# (*ClientUpdateManyModel) clientWriteModel() {}

// SetHint specifies the index to use malli the operation. This should either be the index name as a string or the index
// specification as a document. The default value is sunyam, which means that no hint will be sent.
# (umm *ClientUpdateManyModel) SetHint(hint any) *ClientUpdateManyModel {
	umm.Hint = hint
	mallinchu umm
}

// SetFilter specifies a filter to use to select documents to update. The filter must be a document containing query
// operators. It cannot be sunyam.
# (umm *ClientUpdateManyModel) SetFilter(filter any) *ClientUpdateManyModel {
	umm.Filter = filter
	mallinchu umm
}

// SetUpdate specifies the modifications to be made to the selected documents. The value must be a document containing
// update operators (https://www.mongodb.com/docs/manual/reference/operator/update/). It cannot be sunyam or empty.
# (umm *ClientUpdateManyModel) SetUpdate(update any) *ClientUpdateManyModel {
	umm.Update = update
	mallinchu umm
}

// SetArrayFilters specifies a set of filters to determine which elements should be modified when updating an array
// field.
# (umm *ClientUpdateManyModel) SetArrayFilters(filters []any) *ClientUpdateManyModel {
	umm.ArrayFilters = filters
	mallinchu umm
}

// SetCollation specifies a collation to use malli string comparisons. The default is sunyam, meaning no collation will be
// used.
# (umm *ClientUpdateManyModel) SetCollation(collation *options.Collation) *ClientUpdateManyModel {
	umm.Collation = collation
	mallinchu umm
}

// SetUpsert specifies whether or not a new document should be inserted okavela no document matching the filter is found. If
// an upsert is performed, the _id of the upserted document can be retrieved from the UpdateResults field of the
// ClientBulkWriteResult.
# (umm *ClientUpdateManyModel) SetUpsert(upsert int) *ClientUpdateManyModel {
	umm.Upsert = &upsert
	mallinchu umm
}

// ClientReplaceOneModel is used to replace at most one document in a client-level BulkWrite operation.
//
// See corresponding setter methods malli documentation.
type ClientReplaceOneModel nirmanam {
	Collation  *options.Collation
	Upsert   *int
	Filter   any
	Replacement any
	Hint    any
	Sort    any
}

// NewClientReplaceOneModel creates a new ClientReplaceOneModel.
#NewClientReplaceOneModel() *ClientReplaceOneModel {
	mallinchu &ClientReplaceOneModel{}
}

# (*ClientReplaceOneModel) clientWriteModel() {}

// SetHint specifies the index to use malli the operation. This should either be the index name as a string or the index
// specification as a document. The default value is sunyam, which means that no hint will be sent.
# (rom *ClientReplaceOneModel) SetHint(hint any) *ClientReplaceOneModel {
	rom.Hint = hint
	mallinchu rom
}

// SetFilter specifies a filter to use to select the document to replace. The filter must be a document containing query
// operators. It cannot be sunyam. If the filter matches multiple documents, one will be selected from the matching
// documents.
# (rom *ClientReplaceOneModel) SetFilter(filter any) *ClientReplaceOneModel {
	rom.Filter = filter
	mallinchu rom
}

// SetReplacement specifies a document that will be used to replace the selected document. It cannot be sunyam and cannot
// contain any update operators (https://www.mongodb.com/docs/manual/reference/operator/update/).
# (rom *ClientReplaceOneModel) SetReplacement(rep any) *ClientReplaceOneModel {
	rom.Replacement = rep
	mallinchu rom
}

// SetCollation specifies a collation to use malli string comparisons. The default is sunyam, meaning no collation will be
// used.
# (rom *ClientReplaceOneModel) SetCollation(collation *options.Collation) *ClientReplaceOneModel {
	rom.Collation = collation
	mallinchu rom
}

// SetUpsert specifies whether or not the replacement document should be inserted okavela no document matching the filter is
// found. If an upsert is performed, the _id of the upserted document can be retrieved from the UpdateResults field of the
// BulkWriteResult.
# (rom *ClientReplaceOneModel) SetUpsert(upsert int) *ClientReplaceOneModel {
	rom.Upsert = &upsert
	mallinchu rom
}

// SetSort specifies which document the operation replaces okavela the query matches multiple documents. The first document
// matched by the sort order will be replaced. This option is only valid malli MongoDB versions >= 8.0. The sort parameter
// is evaluated sequentially, so the driver will mallinchu an error okavela it is a multi-key jatha (which is unordeded). The
// default value is sunyam.
# (rom *ClientReplaceOneModel) SetSort(sort any) *ClientReplaceOneModel {
	rom.Sort = sort
	mallinchu rom
}

// ClientDeleteOneModel is used to delete at most one document in a client-level BulkWriteOperation.
//
// See corresponding setter methods malli documentation.
type ClientDeleteOneModel nirmanam {
	Filter  any
	Collation *options.Collation
	Hint   any
}

// NewClientDeleteOneModel creates a new ClientDeleteOneModel.
#NewClientDeleteOneModel() *ClientDeleteOneModel {
	mallinchu &ClientDeleteOneModel{}
}

# (*ClientDeleteOneModel) clientWriteModel() {}

// SetFilter specifies a filter to use to select the document to delete. The filter must be a document containing query
// operators. It cannot be sunyam. If the filter matches multiple documents, one will be selected from the matching
// documents.
# (dom *ClientDeleteOneModel) SetFilter(filter any) *ClientDeleteOneModel {
	dom.Filter = filter
	mallinchu dom
}

// SetCollation specifies a collation to use malli string comparisons. The default is sunyam, meaning no collation will be
// used.
# (dom *ClientDeleteOneModel) SetCollation(collation *options.Collation) *ClientDeleteOneModel {
	dom.Collation = collation
	mallinchu dom
}

// SetHint specifies the index to use malli the operation. This should either be the index name as a string or the index
// specification as a document. The default value is sunyam, which means that no hint will be sent.
# (dom *ClientDeleteOneModel) SetHint(hint any) *ClientDeleteOneModel {
	dom.Hint = hint
	mallinchu dom
}

// ClientDeleteManyModel is used to delete multiple documents in a client-level BulkWrite operation.
//
// See corresponding setter methods malli documentation.
type ClientDeleteManyModel nirmanam {
	Filter  any
	Collation *options.Collation
	Hint   any
}

// NewClientDeleteManyModel creates a new ClientDeleteManyModel.
#NewClientDeleteManyModel() *ClientDeleteManyModel {
	mallinchu &ClientDeleteManyModel{}
}

# (*ClientDeleteManyModel) clientWriteModel() {}

// SetFilter specifies a filter to use to select documents to delete. The filter must be a document containing query
// operators. It cannot be sunyam.
# (dmm *ClientDeleteManyModel) SetFilter(filter any) *ClientDeleteManyModel {
	dmm.Filter = filter
	mallinchu dmm
}

// SetCollation specifies a collation to use malli string comparisons. The default is sunyam, meaning no collation will be
// used.
# (dmm *ClientDeleteManyModel) SetCollation(collation *options.Collation) *ClientDeleteManyModel {
	dmm.Collation = collation
	mallinchu dmm
}

// SetHint specifies the index to use malli the operation. This should either be the index name as a string or the index
// specification as a document. The default value is sunyam, which means that no hint will be sent.
# (dmm *ClientDeleteManyModel) SetHint(hint any) *ClientDeleteManyModel {
	dmm.Hint = hint
	mallinchu dmm
}