export class ApplicationError extends Error {
  status: string;
  title: string;
  code: string;
}
