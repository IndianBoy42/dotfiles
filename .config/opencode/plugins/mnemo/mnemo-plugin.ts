/**
 * Mnemo Plugin for OpenCode
 * Provides persistent project memory across sessions
 */

import { execSync } from 'child_process';
import { basename } from 'path';

function runMnemo(args) {
  try {
    return execSync('mnemo ' + args.join(' '), {
      encoding: 'utf-8',
      timeout: 10000,
    }).trim();
  } catch (error) {
    return 'Error: ' + error.message;
  }
}

function getProjectName(cwd) {
  return basename(cwd);
}

function getMnemoContext(project) {
  const context = runMnemo(['context', project]);
  if (context.includes('Error') || context.includes('No context')) {
    return '';
  }
  return context;
}

export default {
  name: 'mnemo',
  version: '1.0.0',
  description: 'Project memory from past AI coding sessions',

  tools: [
    {
      name: 'mnemo_search',
      description: 'Search past AI coding sessions for relevant context',
      parameters: {
        type: 'object',
        properties: {
          query: { type: 'string', description: 'Search query' },
          limit: { type: 'number', description: 'Max results (default: 10)' },
        },
        required: ['query'],
      },
      execute: async (params) => {
        return runMnemo(['search', params.query, '--limit', (params.limit || 10).toString()]);
      },
    },
    {
      name: 'mnemo_context',
      description: 'Get context summary for a project',
      parameters: {
        type: 'object',
        properties: {
          project: { type: 'string', description: 'Project name' },
        },
        required: ['project'],
      },
      execute: async (params) => {
        return getMnemoContext(params.project) || 'No context available.';
      },
    },
  ],

  experimental: {
    session: {
      compacting: async (summary, ctx) => {
        const project = getProjectName(ctx.cwd);
        const mnemoContext = getMnemoContext(project);
        if (!mnemoContext) return summary;
        return summary + '\n\n---\n## Project Memory (mnemo)\n' + mnemoContext + '\n---';
      },
    },
  },
};
