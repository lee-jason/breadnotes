import React from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { useRecentBreadEntries } from '../hooks/useBreadEntries';
import { BreadEntryCard } from '../components/BreadEntryCard';

export const Home: React.FC = () => {
  const { isAuthenticated } = useAuth();
  const { entries, isLoading } = useRecentBreadEntries();

  return (
    <div className="px-4">
      <div className="text-center py-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          Welcome to BreadNotes 🍞
        </h1>
        <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
          Document your bread baking journey, share your experiences, and discover 
          amazing creations from fellow bakers around the world.
        </p>
        
        {!isAuthenticated && (
          <div className="space-x-4">
            <Link
              to="/login"
              className="bg-amber-600 hover:bg-amber-700 text-white px-6 py-3 rounded-lg font-medium inline-block"
            >
              Get Started
            </Link>
            <Link
              to="/learn-more"
              className="text-amber-600 hover:text-amber-700 px-6 py-3 rounded-lg font-medium inline-block"
            >
              Learn More
            </Link>
          </div>
        )}
      </div>

      <div className="mt-12">
        <h2 className="text-2xl font-bold text-gray-900 mb-6">
          Recent Bread Creations
        </h2>
        
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
                showUser={true}
              />
            ))}
          </div>
        ) : (
          <div className="text-center py-12">
            <div className="text-6xl mb-4">🥖</div>
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              No bread entries yet
            </h3>
            <p className="text-gray-600 mb-6">
              Be the first to share your bread baking experience!
            </p>
            {isAuthenticated && (
              <Link
                to="/create"
                className="bg-amber-600 hover:bg-amber-700 text-white px-6 py-2 rounded-lg font-medium"
              >
                Create Your First Entry
              </Link>
            )}
          </div>
        )}
      </div>
    </div>
  );
};