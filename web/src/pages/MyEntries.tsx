import React from 'react';
import { Link, Navigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { useBreadEntries } from '../hooks/useBreadEntries';
import { BreadEntryCard } from '../components/BreadEntryCard';

export const MyEntries: React.FC = () => {
  const { isAuthenticated } = useAuth();
  const { entries, isLoading } = useBreadEntries();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  return (
    <div className="px-4">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-3xl font-bold text-gray-900">My Bread Entries</h1>
        <Link
          to="/create"
          className="bg-amber-600 hover:bg-amber-700 text-white px-4 py-2 rounded-md font-medium"
        >
          Create New Entry
        </Link>
      </div>

      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[1, 2, 3, 4, 5, 6].map((i) => (
            <div key={i} className="bg-white rounded-lg shadow-sm border border-gray-200 p-4 animate-pulse">
              <div className="h-48 bg-gray-300 rounded mb-4"></div>
              <div className="h-4 bg-gray-300 rounded mb-2"></div>
              <div className="h-3 bg-gray-300 rounded mb-3 w-3/4"></div>
              <div className="h-3 bg-gray-300 rounded w-1/2"></div>
            </div>
          ))}
        </div>
      ) : entries.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {entries.map((entry) => (
            <BreadEntryCard
              key={entry.id}
              entry={entry}
              showUser={false}
            />
          ))}
        </div>
      ) : (
        <div className="text-center py-12">
          <div className="text-6xl mb-4">📝</div>
          <h3 className="text-lg font-medium text-gray-900 mb-2">
            No entries yet
          </h3>
          <p className="text-gray-600 mb-6">
            Start documenting your bread baking journey by creating your first entry.
          </p>
          <Link
            to="/create"
            className="bg-amber-600 hover:bg-amber-700 text-white px-6 py-2 rounded-lg font-medium"
          >
            Create Your First Entry
          </Link>
        </div>
      )}
    </div>
  );
};