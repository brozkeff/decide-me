import { execFileSync } from 'node:child_process'
import { MODELS } from '../src/models.ts'
console.log(JSON.stringify({
  version: process.env.APP_VERSION,
  commit: execFileSync('git', ['rev-parse', 'HEAD'], { encoding: 'utf8' }).trim(),
  kneejerk: execFileSync('git', ['-C', 'vendor/kneejerk', 'rev-parse', 'HEAD'], { encoding: 'utf8' }).trim(),
  models: MODELS,
}, null, 2))
