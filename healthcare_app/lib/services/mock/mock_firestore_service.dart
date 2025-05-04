// Mock implementation of Cloud Firestore service

import 'dart:async';

// Example data structure (adjust as needed for your app's models)
class MockDocumentSnapshot {
  final String id;
  final Map<String, dynamic> _data;

  MockDocumentSnapshot({required this.id, required Map<String, dynamic> data}) : _data = data;

  Map<String, dynamic>? data() => _data;
  bool get exists => true; // Assume documents always exist in mock
}

class MockQuerySnapshot {
  final List<MockDocumentSnapshot> docs;
  MockQuerySnapshot({required this.docs});
}

class MockCollectionReference {
  final String path;
  final MockFirestoreService _service;

  MockCollectionReference(this.path, this._service);

  // Simulate adding a document
  Future<MockDocumentReference> add(Map<String, dynamic> data) async {
    return _service._addDocument(path, data);
  }

  // Simulate getting documents
  Future<MockQuerySnapshot> get() async {
    return _service._getCollection(path);
  }

  // Simulate getting a specific document
  MockDocumentReference doc(String id) {
    return MockDocumentReference('$path/$id', _service);
  }

  // Simulate querying (very basic example)
  MockQuery where(String field, {dynamic isEqualTo}) {
    return MockQuery(path, _service, field, isEqualTo);
  }
}

class MockDocumentReference {
  final String path;
  final MockFirestoreService _service;

  MockDocumentReference(this.path, this._service);

  String get id => path.split('/').last;

  // Simulate getting a document
  Future<MockDocumentSnapshot> get() async {
    return _service._getDocument(path);
  }

  // Simulate setting/overwriting a document
  Future<void> set(Map<String, dynamic> data) async {
    _service._setDocument(path, data);
  }

  // Simulate updating a document
  Future<void> update(Map<String, dynamic> data) async {
    _service._updateDocument(path, data);
  }

  // Simulate deleting a document
  Future<void> delete() async {
    _service._deleteDocument(path);
  }
}

// Basic mock query class
class MockQuery {
  final String path;
  final MockFirestoreService _service;
  final String? _filterField;
  final dynamic _filterValue;

  MockQuery(this.path, this._service, this._filterField, this._filterValue);

  Future<MockQuerySnapshot> get() async {
    return _service._getCollection(path, filterField: _filterField, filterValue: _filterValue);
  }
}


class MockFirestoreService {
  // In-memory store for documents { 'collectionPath/docId': {data} }
  final Map<String, Map<String, dynamic>> _store = {};
  int _docIdCounter = 0;

  // Simulate getting a collection reference
  MockCollectionReference collection(String path) {
    return MockCollectionReference(path, this);
  }

  // Internal method to add a document
  Future<MockDocumentReference> _addDocument(String collectionPath, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate delay
    final docId = 'mock_doc_${_docIdCounter++}';
    final docPath = '$collectionPath/$docId';
    _store[docPath] = Map<String, dynamic>.from(data); // Store a copy
    print('MockFirestore: Added doc $docId to $collectionPath');
    return MockDocumentReference(docPath, this);
  }

  // Internal method to get documents in a collection
  Future<MockQuerySnapshot> _getCollection(String collectionPath, {String? filterField, dynamic filterValue}) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate delay
    final docs = <MockDocumentSnapshot>[];
    _store.forEach((path, data) {
      if (path.startsWith('$collectionPath/')) {
        bool match = true;
        if (filterField != null && filterValue != null) {
          match = data[filterField] == filterValue;
        }
        if (match) {
          docs.add(MockDocumentSnapshot(id: path.split('/').last, data: Map<String, dynamic>.from(data)));
        }
      }
    });
    print('MockFirestore: Got ${docs.length} docs from $collectionPath');
    return MockQuerySnapshot(docs: docs);
  }

  // Internal method to get a specific document
  Future<MockDocumentSnapshot> _getDocument(String docPath) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate delay
    if (_store.containsKey(docPath)) {
      print('MockFirestore: Got doc $docPath');
      return MockDocumentSnapshot(id: docPath.split('/').last, data: Map<String, dynamic>.from(_store[docPath]!));
    } else {
      print('MockFirestore: Doc $docPath not found');
      // Simulate non-existent document - adjust as needed
      return MockDocumentSnapshot(id: docPath.split('/').last, data: {}); 
    }
  }

  // Internal method to set/overwrite a document
  Future<void> _setDocument(String docPath, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate delay
    _store[docPath] = Map<String, dynamic>.from(data);
    print('MockFirestore: Set doc $docPath');
  }

  // Internal method to update a document
  Future<void> _updateDocument(String docPath, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate delay
    if (_store.containsKey(docPath)) {
      _store[docPath]!.addAll(data);
      print('MockFirestore: Updated doc $docPath');
    } else {
      print('MockFirestore: Update failed - Doc $docPath not found');
      // Handle error or create if needed based on Firestore behavior
    }
  }

  // Internal method to delete a document
  Future<void> _deleteDocument(String docPath) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate delay
    if (_store.remove(docPath) != null) {
      print('MockFirestore: Deleted doc $docPath');
    } else {
      print('MockFirestore: Delete failed - Doc $docPath not found');
    }
  }
}

