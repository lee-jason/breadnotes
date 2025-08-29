import React from 'react';
import type { BreadEntry } from '../types';

interface BreadEntryCardProps {
  entry: BreadEntry;
  showUser?: boolean;
  onClick?: () => void;
}

export const BreadEntryCard: React.FC<BreadEntryCardProps> = ({ 
  entry, 
  showUser = false, 
  onClick 
}) => {
  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  return (
    <div
      className={`bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden ${
        onClick ? 'cursor-pointer hover:shadow-md transition-shadow' : ''
      }`}
      onClick={onClick}
    >
      {entry.image_url && (
        <img
          src={entry.image_url}
          alt={entry.title}
          className="w-full h-48 object-cover"
        />
      )}
      
      <div className="p-4">
        <h3 className="text-lg font-medium text-gray-900 mb-2">
          {entry.title}
        </h3>
        
        {entry.notes && (
          <p className="text-gray-600 text-sm mb-3 line-clamp-3">
            {entry.notes}
          </p>
        )}
        
        <div className="flex items-center justify-between text-sm text-gray-500">
          <span>{formatDate(entry.created_at)}</span>
          
          {showUser && (
            <div className="flex items-center space-x-2">
              {entry.user.profile_picture && (
                <img
                  src={entry.user.profile_picture}
                  alt={entry.user.name}
                  className="w-6 h-6 rounded-full"
                />
              )}
              <span>{entry.user.name}</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};