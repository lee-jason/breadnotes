import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { breadService } from '../services/api';
import { CreateBreadEntryData } from '../types';

export const useBreadEntries = () => {
  const { data: entries = [], isLoading, refetch } = useQuery({
    queryKey: ['breadEntries'],
    queryFn: breadService.getUserEntries,
  });
  
  return {
    entries,
    isLoading,
    refetch,
  };
};

export const useRecentBreadEntries = () => {
  const { data: entries = [], isLoading } = useQuery({
    queryKey: ['recentBreadEntries'],
    queryFn: breadService.getRecentEntries,
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
  
  return {
    entries,
    isLoading,
  };
};

export const useBreadEntry = (id: string) => {
  const { data: entry, isLoading } = useQuery({
    queryKey: ['breadEntry', id],
    queryFn: () => breadService.getEntry(id),
    enabled: !!id,
  });
  
  return {
    entry,
    isLoading,
  };
};

export const useCreateBreadEntry = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: breadService.createEntry,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['breadEntries'] });
      queryClient.invalidateQueries({ queryKey: ['recentBreadEntries'] });
    },
  });
};

export const useUpdateBreadEntry = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: CreateBreadEntryData }) =>
      breadService.updateEntry(id, data),
    onSuccess: (updatedEntry) => {
      queryClient.invalidateQueries({ queryKey: ['breadEntries'] });
      queryClient.invalidateQueries({ queryKey: ['breadEntry', updatedEntry.id] });
    },
  });
};

export const useDeleteBreadEntry = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: breadService.deleteEntry,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['breadEntries'] });
      queryClient.invalidateQueries({ queryKey: ['recentBreadEntries'] });
    },
  });
};