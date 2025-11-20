// Simple in-memory Firestore-like mock for development
// This replaces external Firebase during local development and tests.
const db = {
  notes: [],
  collection(name) {
    return {
      // Add a document and return an object similar to Firestore's add()
      add: async (data) => {
        const id = Math.random().toString(36).substring(7);
        db.notes.push({ id, ...data });
        return { id };
      },
      // where(...).orderBy(...).get() -> returns { docs: [ { id, data: () => {...} } ] }
      where(field, op, value) {
        return {
          orderBy() {
            return {
              get: async () => ({
                docs: db.notes
                  .filter(note => note[field] === value)
                  .sort((a, b) => (a.createdAt < b.createdAt ? 1 : -1))
                  .map(note => ({ id: note.id, data: () => note }))
              })
            };
          }
        };
      },
      doc(id) {
        return {
          delete: async () => {
            const index = db.notes.findIndex(note => note.id === id);
            if (index > -1) db.notes.splice(index, 1);
          }
        };
      }
    };
  }
};

module.exports = { db };
